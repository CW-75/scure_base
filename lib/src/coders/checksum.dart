part of 'coder.dart';

class Checksum implements Coder<Uint8List, Uint8List> {
  int length;
  Uint8List Function(Uint8List data) fn;

  Checksum(this.length, this.fn);

  Uint8List encode(Uint8List data) {
    final sum = fn(data).sublist(0, length);
    final res = Uint8List(data.length + length);
    res.setAll(0, data);
    res.setAll(data.length, sum);
    return res;
  }

  Uint8List decode(Uint8List data) {
    if (data.length < length) {
      throw Exception('Data too short for checksum');
    }
    final payload = data.sublist(0, data.length - length);
    final oldChecksum = data.sublist(data.length - length);
    final newCheksum = fn(payload).sublist(0, length);
    for (var i = 0; i < oldChecksum.length; i++) {
      if (oldChecksum[i] != newCheksum[i]) {
        throw Exception('Invalid checksum: ');
      }
    }
    return payload;
  }
}

class Bech32Checksum implements Coder<Bech32Structure, Bech32Structure> {
  final Bech32Encoding encoding;

  Bech32Structure encode(Bech32Structure data) {
    final prefiLowered = data.prefix.toLowerCase();
    final len = data.prefix.length;
    var chk = 1;
    for (var i = 0; i < len; i++) {
      final c = prefiLowered.codeUnitAt(i);
      if (c < 33 || c > 126) throw 'Invalid prefix character';
      chk = _bech32Polymod(chk) ^ (c >> 5);
    }
    chk = _bech32Polymod(chk);
    for (var i = 0; i < len; i++) {
      chk = _bech32Polymod(chk) ^ (prefiLowered.codeUnitAt(i) & 0x1f);
    }
    for (var v in data.words) {
      chk = _bech32Polymod(chk) ^ v;
    }
    for (var i = 0; i < 6; i++) {
      chk = _bech32Polymod(chk);
    }
    chk ^= encoding == Bech32Encoding.bech32 ? 0x1 : 0x2bc830a3;
    final checksumWords = convertRadix2([chk % powers[30]], 30, 5, false);
    return (prefix: prefiLowered, words: data.words + checksumWords);
  }

  decode(Bech32Structure data) {
    final words = data.words.sublist(0, data.words.length - 6);
    final checksum = encode((prefix: data.prefix, words: words));
    if (!data.words.toString().endsWith(checksum.words.toString())) {
      throw Exception('Invalid checksum');
    }
    return (prefix: data.prefix, words: words);
  }

  Bech32Checksum({this.encoding = Bech32Encoding.bech32});
}

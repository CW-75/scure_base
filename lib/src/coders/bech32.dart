part of 'coder.dart';

enum Bech32Encoding { bech32, bech32m }

typedef Bech32Structure = ({List<int> words, String prefix});
typedef Bech32DecodedWithBytes = ({
  Uint8List bytes,
  List<int> words,
  String prefix,
});

/// Bech32 polymod generators.
/// These are used to calculate the checksum for Bech32 strings.
const _polymodGenerators = [
  0x3b6a57b2,
  0x26508e6d,
  0x1ea119fa,
  0x3d4233dd,
  0x2a1462b3,
];

int _bech32Polymod(int pre) {
  final b = pre >> 25;
  int chk = (pre & 0x1ffffff) << 5;
  for (var i = 0; i < _polymodGenerators.length; i++) {
    if (((b >> i) & 1) == 1) {
      chk ^= _polymodGenerators[i];
    }
  }
  return chk;
}

void _validateBech32Data(Bech32Structure data, [int? limit]) {
  final (:prefix, :words) = data;
  final plen = prefix.length;
  if (plen == 0) throw 'Invalid prefix length';
  final actualLength = plen + 7 + words.length;
  if (limit != null && actualLength > limit) {
    throw 'Lenght limit exceeded, actual: $actualLength, limit: $limit';
  }
}

void _validateDecodedBech32String(
  String str, {
  int? limit,
}) {
  final strlen = str.length;
  if (strlen < 8 || (limit != null && strlen > limit)) {
    throw 'Invalid Bech32 string length: $strlen';
  }
  final lowered = str.toLowerCase();
  if (str != lowered && str != str.toUpperCase()) {
    throw 'Bech32 string must be lowercase or uppercase';
  }
  final sepIndex = lowered.lastIndexOf('1');
  if (sepIndex == 0 || sepIndex == -1) {
    throw 'Bech32 string must contain a separator "1"';
  }
  final data = lowered.substring(sepIndex + 1);
  if (data.length < 6) {
    throw 'Bech32 string must contain at least 6 data characters after the separator';
  }
}

class Bech32Coder implements Coder<Bech32Structure, String> {
  final Bech32Encoding encoding;
  final Chainer _enchainedElements;
  final Radix2 _words = Radix2(5);

  Bech32Coder(this._enchainedElements, {this.encoding = Bech32Encoding.bech32});

  @override
  String encode(Bech32Structure from, [int? limit]) {
    _validateBech32Data(from, limit);
    return _enchainedElements.encode(from);
  }

  @override
  Bech32Structure decode(String str) {
    _validateDecodedBech32String(str);
    return _enchainedElements.decode(str);
  }

  List<int> toWords(Uint8List data) => _words.encode(data);
  Uint8List fromWords(List<int> data) => _words.decode(data);

  String encodeFromBytes(String prefix, Uint8List bytes) =>
      encode((words: toWords(bytes), prefix: prefix));

  Bech32DecodedWithBytes decodeToBytes(String str) {
    final (:words, :prefix) = decode(str);
    return (bytes: fromWords(words), words: words, prefix: prefix);
  }
}

Bech32Coder coder = Bech32Coder(
  Chainer([
    Bech32Checksum(encoding: Bech32Encoding.bech32),
    Bech32Formatter('qpzry9x8gf2tvdw0s3jn54khce6mua7l'),
  ]),
  encoding: Bech32Encoding.bech32,
);

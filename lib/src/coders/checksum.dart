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
    final payload = data.sublist(data.length - length);
    final oldChecksum = data.sublist(0, data.length - length);
    final newCheksum = fn(oldChecksum).sublist(0, length);
    if (oldChecksum != newCheksum) {
      throw 'Invalid Cheksum';
    }
    return payload;
  }
}

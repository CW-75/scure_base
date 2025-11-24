import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

enum Encodings { utf8, hex, base64 }

class Buffer extends ListBase<int> {
  late Uint8List _bytes;

  Buffer(int length) {
    _bytes = Uint8List(length);
  }

  factory Buffer.fromList(List<int> list) {
    Buffer buf = Buffer(list.length);
    buf.bytes.setAll(0, list);
    return buf;
  }

  factory Buffer.from(String data, [Encodings option = Encodings.utf8]) {
    switch (option) {
      case Encodings.utf8:
        Buffer buf = Buffer(data.length);
        buf.bytes.setAll(0, data.codeUnits);
        return buf;
      case Encodings.hex:
        Buffer buf = Buffer(data.length ~/ 2);
        final List<int> hexList = [];
        for (int i = 0; i < data.length; i += 2) {
          final hexByte = data.substring(i, i + 2);
          hexList.add(int.parse(hexByte, radix: 16));
        }
        buf.bytes.setAll(0, hexList.toList());
        return buf;
      case Encodings.base64:
        Buffer buf = Buffer(data.length ~/ 4 * 3);
        final decoded = base64Decode(data);
        buf.bytes.setAll(0, decoded);
        return buf;
    }
  }
  @override
  String toString([Encodings option = Encodings.utf8]) {
    switch (option) {
      case Encodings.utf8:
        return bytes.map((e) => String.fromCharCode(e)).join();
      case Encodings.hex:
        return bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
      case Encodings.base64:
        return base64Encode(bytes);
    }
  }

  @override
  Buffer sublist(int start, [int? end]) {
    if (end != null && end > bytes.length) {
      end = _bytes.length % end;
    }
    return Buffer.fromList(super.sublist(start, end));
  }

  @override
  int get length => bytes.length;

  @override
  set length(int newLength) {
    bytes.length = newLength;
  }

  @override
  int operator [](int index) => bytes[index];

  @override
  void operator []=(int index, int value) {
    bytes[index] = value;
  }

  @override
  Iterator<int> get iterator => bytes.iterator;

  Uint8List get bytes => _bytes;
}

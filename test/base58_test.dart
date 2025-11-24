import 'dart:typed_data';

import 'package:scure_base/src/coders/coder.dart';
import 'package:test/test.dart';

import 'mocks/base58mocks.dart';

void printBufHex(Uint8List data) {
  final hex = data.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  print(hex);
}

Uint8List asciiToArray(String str) =>
    Uint8List.fromList(str.split('').map((c) => c.codeUnitAt(0)).toList());
void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Test encoding base58', () {
      final base58EncodedData = base58.encode(vectors1[0].decoded);
      expect(base58EncodedData, vectors1[0].encoded);
      expect(base58.decode(base58EncodedData), equals(vectors1[0].decoded));
    });
  });
}

import 'dart:typed_data';

import 'package:scure_base/scure_base.dart';
import 'package:test/test.dart';

import 'mocks/vectors/base58_vectors.dart' as b58v;
import 'mocks/vectors/base58xrm_vectors.dart' as b58xrmv;

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
      for (final vector in b58v.vectors) {
        final coder = vector.isXrp == true ? base58Xrp : base58;
        final base58EncodedData = coder.encode(vector.decoded);
        expect(base58EncodedData, vector.encoded);
        expect(coder.decode(base58EncodedData), equals(vector.decoded));
      }
    });

    test('Test encoding base58xrm vectors', () {
      for (var i = 0; i < b58xrmv.vectors.validAddrss.length; i++) {
        final decAddress = b58xrmv.vectors.decodedAddrs[i];
        final validAddress = b58xrmv.vectors.validAddrss[i];
        expect(
          validAddress,
          base58Xrm.encode(Buffer.from(decAddress, Encodings.hex).bytes),
        );
        expect(
          base58Xrm.decode(validAddress),
          Buffer.from(decAddress, Encodings.hex).bytes,
        );
      }
    });
  });
}

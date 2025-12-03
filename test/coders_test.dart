import 'package:scure_base/scure_base.dart';
import 'package:scure_base/src/coders/coder.dart';
import 'package:test/test.dart';

import 'mocks/vectors/bech32_vectors.dart';

typedef Bech32TestStruct = ({String string, String prefix, List<int> words});

List<Bech32TestStruct> BECH32_VALID = [
  (string: 'A12UEL5L', prefix: 'A', words: []),
];

void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });
    test('Radix conversion byte array for base256 -> UTF-8', () {
      final data = Buffer.from(
        "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f",
        Encodings.hex,
      );
      final radix = Radix(256);
      final encoded = radix.encode(data.bytes);
      expect(
        encoded,
        equals([
          0x00,
          0x01,
          0x02,
          0x03,
          0x04,
          0x05,
          0x06,
          0x07,
          0x08,
          0x09,
          0x0a,
          0x0b,
          0x0c,
          0x0d,
          0x0e,
          0x0f,
          0x10,
          0x11,
          0x12,
          0x13,
          0x14,
          0x15,
          0x16,
          0x17,
          0x18,
          0x19,
          0x1a,
          0x1b,
          0x1c,
          0x1d,
          0x1e,
          0x1f,
        ]),
      );
    });
  });
  test('Radix conversion byte array for base256 to base32', () {
    final data = Buffer.from("ff", Encodings.hex);
    final radix = Radix(32);
    final encoded = radix.encode(data.bytes);
    expect(encoded, equals([7, 31]));
  });

  test('Bech32 Test', () {
    for (final v in bech32ValidVectors) {
      final encoded = bech32.encode((prefix: v.prefix, words: v.words));
      expect(encoded, equals(v.string.toLowerCase()));
      final (:prefix, :words) = bech32.decode(encoded);
      expect(prefix, equals(v.prefix.toLowerCase()));
      expect(words, equals(v.words));
    }
  });
}

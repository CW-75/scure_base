import 'dart:convert';
import 'package:scure_base/src/buffer.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Buffer from Hex', () {
      final data = Buffer.from(
        "0065a16059864a2fdbc7c99a4723a8395bc6f188eb",
        Encodings.hex,
      );
      expect(
        data.bytes,
        equals([
          0x00,
          0x65,
          0xa1,
          0x60,
          0x59,
          0x86,
          0x4a,
          0x2f,
          0xdb,
          0xc7,
          0xc9,
          0x9a,
          0x47,
          0x23,
          0xa8,
          0x39,
          0x5b,
          0xc6,
          0xf1,
          0x88,
          0xeb,
        ]),
      );
    });
    test('Buffer from Utf8', () {
      final data = Buffer.from("hello world");
      expect(
        data.bytes,
        equals([104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100]),
      );
    });
    test('Buffer from base64', () {
      final encoded64 = base64Encode(
        Buffer.from("0065a16059864a2fdbc7c99a4723a8395bc6f188eb").bytes,
      );
      final data = Buffer.from(encoded64, Encodings.base64);
      expect(
        data.toString(Encodings.base64),
        equals("MDA2NWExNjA1OTg2NGEyZmRiYzdjOTlhNDcyM2E4Mzk1YmM2ZjE4OGVi"),
      );
    });
  });
}

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
        data.toString(Encodings.hex),
        equals(
          "[00, 65, a1, 60, 59, 86, 4a, 2f, db, c7, c9, 9a, 47, 23, a8, 39, 5b, c6, f1, 88, eb]",
        ),
      );
    });
    test('Buffer from Utf8', () {
      final data = Buffer.from("0065a16059864a2fdbc7c99a4723a8395bc6f188eb");
      expect(
        data.toString(),
        equals(
          "[30, 30, 36, 35, 61, 31, 36, 30, 35, 39, 38, 36, 34, 61, 32, 66, 64, 62, 63, 37, 63, 39, 39, 61, 34, 37, 32, 33, 61, 38, 33, 39, 35, 62, 63, 36, 66, 31, 38, 38, 65, 62]",
        ),
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

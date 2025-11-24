import 'dart:typed_data';

import 'package:scure_base/scure_base.dart';

import '../../base58_test.dart';

typedef TestSruct = ({String encoded, Uint8List decoded, bool? isXrp});

final List<TestSruct> vectors = [
  (
    encoded: "StV1DL6CwTryKyV",
    decoded: asciiToArray("hello world"),
    isXrp: false,
  ),
  (
    encoded: "StV1DL6CwTryKyV",
    decoded: Buffer.from("hello world").bytes,
    isXrp: false,
  ),
  (
    encoded: "StVrDLaUATiyKyV",
    decoded: asciiToArray("hello world"),
    isXrp: true,
  ),
  (
    encoded: "11StV1DL6CwTryKyV",
    decoded: asciiToArray("\u0000\u0000hello world"),
    isXrp: false,
  ),
  (encoded: '', decoded: Uint8List(0), isXrp: false),
  (
    encoded: 'ABnLTmg',
    decoded: Buffer.fromList([0x51, 0x6b, 0x6f, 0xcd, 0x0f]).bytes,
    isXrp: false,
  ),
  (
    decoded: asciiToArray('Hello World!'),
    encoded: '2NEpo7TZRRrLZSi2U',
    isXrp: false,
  ),
  (
    decoded: asciiToArray('The quick brown fox jumps over the lazy dog.'),
    encoded: 'USm3fpXnKG5EUBx2ndxBDMPVciP5hGey2Jh4NDv6gmeo1LkMeiKrLJUUBk6Z',
    isXrp: false,
  ),
  (
    decoded: Uint8List.fromList([0x00, 0x00, 0x28, 0x7f, 0xb4, 0xcd]),
    encoded: '11233QC4',
    isXrp: false,
  ),
];

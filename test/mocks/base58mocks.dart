import 'dart:convert';
import 'dart:typed_data';

import '../base58_test.dart';

typedef TestSruct = ({String encoded, Uint8List decoded, bool? isXrp});

final List<TestSruct> vectors1 = [
  (
    encoded: "StV1DL6CwTryKyV",
    decoded: asciiToArray("hello world"),
    isXrp: false,
  ),
];

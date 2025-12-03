/// A library for encoding and decoding data using various coders.
library;

import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:scure_base/src/buffer.dart';
import 'package:scure_base/src/types/coder.dart';
import 'package:scure_base/src/utils.dart';

part 'alphabet.dart';
part 'bitcoders.dart';
part 'bech32.dart';
part 'chain.dart';
part 'checksum.dart';
part 'const.dart';
part 'string_coders.dart';

abstract interface class Coder<F, T> {
  T encode(F from);
  F decode(T to);
}

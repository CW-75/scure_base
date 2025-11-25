part of 'coder.dart';

/// A class that chains multiple coders together, allowing for complex encoding and decoding operations.
///
/// This class takes a list of coders and applies them in sequence, allowing for the transformation of data through multiple stages.
///
/// example usage:
/// ```dart
/// final chainer = Chainer([Coder1(), Coder2(), Coder3()]);
/// ```
class Chainer<T, U> extends Coder<T, U> {
  List<Coder<dynamic, dynamic>> args;
  Chainer(this.args);

  Function id = (a) => a;
  Function wrap(Function a, Function b) =>
      (c) => a(b(c));

  U encode(dynamic from) {
    final encodedFunc = args
        .map((e) => e.encode)
        .toList()
        .reversed
        .fold(id, wrap);
    return encodedFunc(from);
  }

  T decode(to) {
    final decodedFunc = args.map((x) => x.decode).toList().fold(id, wrap);
    return decodedFunc(to);
    // return args.map((x) => x.decode).fold(id, wrap);
  }
}

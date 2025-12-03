part of 'coder.dart';

final class Radix implements Coder<Uint8List, List<int>> {
  final int num;
  Radix(this.num);

  List<int> encode(Uint8List from) => convertRadix(from, 256, num);

  Uint8List decode(List<int> to) =>
      Uint8List.fromList(convertRadix(to, num, 256));
}

final class Radix2 implements Coder<Uint8List, List<int>> {
  final int bits;
  bool padding;

  Radix2(this.bits, [this.padding = false]) {
    if (bits <= 0 || bits > 32) {
      throw 'Radix2: bits must be in range 1..32';
    }
    if (radix2carry(8, bits) > 32 || radix2carry(bits, 8) > 32) {
      throw 'Radix2: carry overflow bits=$bits';
    }
  }

  List<int> encode(Uint8List data) {
    return convertRadix2(data, 8, bits, !padding);
  }

  Uint8List decode(List<int> to) {
    return Uint8List.fromList(convertRadix2(to, bits, 8, padding));
  }
}

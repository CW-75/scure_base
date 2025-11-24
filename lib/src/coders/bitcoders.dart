part of 'coder.dart';

class Radix implements Coder<Uint8List, List<int>> {
  final int num;
  Radix(this.num);

  List<int> encode(Uint8List from) => convertRadix(from, 256, num);

  Uint8List decode(List<int> to) =>
      Uint8List.fromList(convertRadix(to, num, 256));
}

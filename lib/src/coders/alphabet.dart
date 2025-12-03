part of 'coder.dart';

final class Alphabet implements Coder<List<int>, List<String>> {
  final List<String> letters;
  final int len;
  final Map<String, int> _indexes;

  Alphabet(String alphabet)
    : letters = alphabet.split(''),
      len = alphabet.length,
      _indexes = alphabet.split('').asMap().map((i, c) => MapEntry(c, i));

  List<String> encode(List<int> data) {
    return data.map((e) {
      if (e < 0 || e >= len) {
        throw Exception('Value out of range for alphabet encoding');
      }
      return letters[e];
    }).toList();
  }

  List<int> decode(List<String> str) {
    return str.map((c) {
      final index = _indexes[c];
      if (index == null) {
        throw Exception('Invalid character in alphabet string');
      }
      return index;
    }).toList();
  }
}

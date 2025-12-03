part of 'coder.dart';

class Joiner implements Coder<List<String>, String> {
  final String separator;

  Joiner([this.separator = '']);

  @override
  String encode(List<String> from) {
    return from.join(separator);
  }

  @override
  List<String> decode(String to) {
    return to.split(separator);
  }
}

/// Coder for Bech32 strings and Bech32Structures.
class Bech32Formatter implements Coder<Bech32Structure, String> {
  Alphabet alphabet;

  /// Encodes a Bech32 structure into a string.
  ///
  /// The [data] parameter is a tuple containing the words and prefix.
  /// returns a Bech32 string in the format '[prefix]1[words]'.
  String encode(Bech32Structure data) {
    return '${data.prefix}1${alphabet.encode(data.words).join('')}';
  }

  /// Decodes a Bech32 string into a Bech32 structure.
  ///
  /// The [str] parameter is the Bech32 string to decode.
  /// It returns a Bech32 structure containing the words and prefix.
  Bech32Structure decode(String str) {
    final separator = str.lastIndexOf('1');
    final prefix = str.substring(0, separator);
    final content = str.substring(separator + 1).toLowerCase();
    final words = alphabet.decode(content.split(''));
    return (words: words, prefix: prefix);
  }

  /// Creates a Bech32 formatter with the given alphabet.
  /// The alphabet should contain 32 characters, each representing a 5-bit value.
  ///
  /// [abc] is the alphabet used for encoding and decoding.
  Bech32Formatter(String abc) : alphabet = Alphabet(abc);
}

part of 'coder.dart';

BytesCoder genBase58(String abc) {
  return Chainer([Radix(58), Alphabet(abc), Joiner('')]);
}

//------------------------- Base58 Coders -------------------------//

/// base58: base64 without ambigous characters +, /, 0, O, I, l.
/// Quadratic (O(n^2)) - so, can't be used on large inputs.
///
/// example:
/// ```dart
/// base58.decode('01abcdef');
/// // => '3UhJW'
/// ```
final BytesCoder base58 = genBase58(
  '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz',
);

/// base58: flickr version. Check out `base58`
final BytesCoder base58Flickr = genBase58(
  '123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ',
);

final BytesCoder base58Xrp = genBase58(
  'rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65jkm8oFqi1tuvAxyz',
);

/// base58: XRP version. Check out `base58`
BytesCoder createBase58Check() {
  Uint8List fnSha256(Uint8List data) =>
      Uint8List.fromList(sha256.convert(sha256.convert(data).bytes).bytes);
  return Chainer([Checksum(4, fnSha256), base58]);
}

BytesCoder base58Check = createBase58Check();

const xmrBlockLen = [0, 2, 3, 5, 6, 7, 9, 10, 11];

/// base58: XMR version. Check out `base58`.
class XmrBase58 implements BytesCoder {
  XmrBase58() : super();

  String encode(Uint8List data) {
    var res = '';
    for (int i = 0; i < data.length; i += 8) {
      final block = Buffer.fromList(data).sublist(i, i + 8);
      res += base58
          .encode(Uint8List.fromList(block))
          .padLeft(xmrBlockLen[block.length], '1');
    }
    return res;
  }

  Uint8List decode(String from) {
    List<int> res = [];
    for (int i = 0; i < from.length; i += 11) {
      final slice = Buffer.from(from).sublist(i, i + 11);
      final blockLen = xmrBlockLen.indexOf(slice.length);
      final block = base58.decode(slice.toString());
      for (int j = 0; j < block.length - blockLen; j++) {
        if (block[j] != 0) {
          throw Exception('Wrong Padding');
        }
      }
      res += block.sublist(block.length - blockLen);
    }
    return Uint8List.fromList(res);
  }
}

///
/// base58: XMR version. Check out `base58`.
/// Done in 8-byte blocks (which equals 11 chars in decoding). Last (non-full) block padded with '1' to size in XMR_BLOCK_LEN.
/// Block encoding significantly reduces quadratic complexity of base58.
BytesCoder base58Xrm = XmrBase58();

// -------------------------------------------------------------------------//

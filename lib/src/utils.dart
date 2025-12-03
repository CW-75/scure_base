import 'dart:math';

/// Converts a list of integers from one radix (base) to another.
///
/// [data] is the list of integers to convert.
/// [from] is the base of the input integers.
/// [to] is the base to convert the integers to.
/// Returns a new list of integers representing the converted values in the target base.
List<int> convertRadix(List<int> data, int from, int to) {
  // base 1 is impossible
  if (from < 2 || to < 2) {
    throw Exception('convertRadix: invalid base, must be >= 2');
  }
  if (data.isEmpty) return [];
  var pos = 0;
  final List<int> res = [];
  final digits = data.map((d) {
    if (d < 0 || d >= from) throw Exception('Invalid integer: $d');
    return d;
  }).toList();

  final dlen = digits.length;
  while (true) {
    var carry = 0;
    var done = true;
    for (var i = pos; i < dlen; i++) {
      final digit = digits[i];
      final fromCarry = from * carry;
      final digitBase = fromCarry + digit;
      if (digitBase < 0 ||
          !digitBase.isFinite ||
          fromCarry / from != carry ||
          digitBase - digit != fromCarry) {
        throw Exception('convertRadix: carry overflow');
      }
      final div = digitBase ~/ to;
      carry = digitBase % to;
      digits[i] = div;
      if (div < 0 || div * to + carry != digitBase) {
        throw Exception('convertRadix: carry overflow');
      }
      if (!done) {
        continue;
      } else if (div == 0) {
        pos = i;
      } else {
        done = false;
      }
    }
    res.add(carry);
    if (done) break;
  }
  for (var i = 0; i < data.length - 1 && data[i] == 0; i++) {
    res.add(0);
  }
  return res.reversed.toList();
}

int _gcd(int a, int b) => (b == 0 ? a : _gcd(b, a % b));
int radix2carry(int from, int to) => from + (to - _gcd(from, to));
List<int> powers = [for (int i = 0; i < 33; i++) pow(2, i).toInt()];

/// Implemented with numbers, because BigInt is 5x slower
List<int> convertRadix2(List<int> data, int from, int to, bool padding) {
  if (from <= 0 || from > 32) throw 'convertRadix2: wrong from=$from';
  if (to <= 0 || to > 32) throw 'convertRadix2: wrong to=$to';
  if (radix2carry(from, to) > 32) {
    throw 'ConvertRadix2: carry overflow from=$from to=$to carryBits=${radix2carry(from, to)}';
  }
  var carry = 0;
  var pos = 0; // bitwise position in current element
  final max = powers[from];
  final mask = powers[to] - 1;
  final List<int> res = [];
  for (final n in data) {
    if (n >= max) throw 'convertRadix2: invalid data word=$n from=$from';
    carry = (carry << from) | n;
    if (pos + from > 32) {
      throw 'convertRadix2: carry overflow pos=$pos from=$from';
    }
    pos += from;
    for (; pos >= to; pos -= to) {
      res.add(((carry >> (pos - to)) & mask) >>> 0);
    }
    final pow = powers[pos];
    carry &= pow - 1; // clean carry, otherwise it will cause overflow
  }
  carry = (carry << (to - pos)) & mask;
  if (!padding && pos >= from) throw 'Excess padding';
  if (!padding && carry > 0) throw 'Non-zero padding $carry';
  if (padding && pos > 0) res.add(carry >>> 0);
  return res;
}

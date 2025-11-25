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

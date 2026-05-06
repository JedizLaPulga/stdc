import 'package:test/test.dart';
import 'package:stdc/stdc.dart';

void main() {
  group('limits.h tests', () {
    test('CHAR_BIT', () {
      expect(stdc.CHAR_BIT, 8);
    });

    test('INT_MIN and INT_MAX', () {
      expect(stdc.INT_MAX, 2147483647);
      expect(stdc.INT_MIN, -2147483648);
    });

    test('LONG limits', () {
      expect(stdc.LONG_MAX, 9223372036854775807);
      expect(stdc.LONG_MIN, -9223372036854775808);
    });
  });
}

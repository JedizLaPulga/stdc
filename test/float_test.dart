import 'package:test/test.dart';
import 'package:stdc/stdc.dart' hide group;

void main() {
  group('float.h tests', () {
    test('FLT_DIG and DBL_DIG', () {
      expect(stdc.FLT_DIG, 6);
      expect(stdc.DBL_DIG, 15);
    });

    test('DBL limits', () {
      expect(stdc.DBL_MAX, 1.7976931348623157e+308);
      expect(stdc.DBL_MIN, 2.2250738585072014e-308);
    });
  });
}

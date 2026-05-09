import 'package:test/test.dart';
import 'package:stdc/stdc.dart';

void main() {
  group('locale.h', () {
    test('LC_ macros should be defined', () {
      expect(stdc.LC_ALL, 0);
      expect(stdc.LC_COLLATE, 1);
      expect(stdc.LC_CTYPE, 2);
      expect(stdc.LC_MONETARY, 3);
      expect(stdc.LC_NUMERIC, 4);
      expect(stdc.LC_TIME, 5);
    });

    test('setlocale should return "C"', () {
      expect(stdc.setlocale(stdc.LC_ALL, "C"), equals("C"));
      expect(stdc.setlocale(stdc.LC_ALL, ""), equals("C"));
    });

    test('localeconv should return standard C defaults', () {
      final lconv = stdc.localeconv();
      expect(lconv.decimal_point, equals("."));
      expect(lconv.thousands_sep, equals(""));
      expect(lconv.grouping, equals(""));
      expect(lconv.int_curr_symbol, equals(""));
      expect(lconv.currency_symbol, equals(""));
      expect(lconv.int_frac_digits, equals(127));
      expect(lconv.frac_digits, equals(127));
      expect(lconv.p_cs_precedes, equals(127));
    });
  });
}

// ignore_for_file: non_constant_identifier_names
/// `<locale.h>` implementation for stdc
///
/// Contains localization utilities.
library;

import 'src/stdc_base.dart';
export 'src/stdc_base.dart';

/// Dart representation of the C `struct lconv`.
/// 
/// Contains localization-specific numeric and monetary formatting rules.
class Lconv {
  final String decimal_point;
  final String thousands_sep;
  final String grouping;
  final String int_curr_symbol;
  final String currency_symbol;
  final String mon_decimal_point;
  final String mon_thousands_sep;
  final String mon_grouping;
  final String positive_sign;
  final String negative_sign;
  final int int_frac_digits;
  final int frac_digits;
  final int p_cs_precedes;
  final int p_sep_by_space;
  final int n_cs_precedes;
  final int n_sep_by_space;
  final int p_sign_posn;
  final int n_sign_posn;

  const Lconv({
    this.decimal_point = ".",
    this.thousands_sep = "",
    this.grouping = "",
    this.int_curr_symbol = "",
    this.currency_symbol = "",
    this.mon_decimal_point = "",
    this.mon_thousands_sep = "",
    this.mon_grouping = "",
    this.positive_sign = "",
    this.negative_sign = "",
    this.int_frac_digits = 127,
    this.frac_digits = 127,
    this.p_cs_precedes = 127,
    this.p_sep_by_space = 127,
    this.n_cs_precedes = 127,
    this.n_sep_by_space = 127,
    this.p_sign_posn = 127,
    this.n_sign_posn = 127,
  });
}

/// Extension on [Stdc] to provide `<locale.h>` functionality.
extension LocaleStdc on Stdc {
  int get LC_ALL => 0;
  int get LC_COLLATE => 1;
  int get LC_CTYPE => 2;
  int get LC_MONETARY => 3;
  int get LC_NUMERIC => 4;
  int get LC_TIME => 5;

  /// Sets the program's current locale.
  /// 
  /// Currently, only the standard `"C"` locale is supported.
  String setlocale(int category, String locale) {
    return "C";
  }

  /// Returns numeric formatting information for the current locale.
  Lconv localeconv() {
    return const Lconv();
  }
}

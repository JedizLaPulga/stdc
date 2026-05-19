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
  /// The decimal point character for non-monetary values.
  final String decimal_point;
  /// The character used to separate groups of digits before the decimal point in non-monetary values.
  final String thousands_sep;
  /// A string that indicates the size of each group of digits in non-monetary values.
  final String grouping;
  /// The international currency symbol.
  final String int_curr_symbol;
  /// The local currency symbol.
  final String currency_symbol;
  /// The decimal point character for monetary values.
  final String mon_decimal_point;
  /// The character used to separate groups of digits before the decimal point in monetary values.
  final String mon_thousands_sep;
  /// A string that indicates the size of each group of digits in monetary values.
  final String mon_grouping;
  /// The string used to indicate a non-negative-valued monetary quantity.
  final String positive_sign;
  /// The string used to indicate a negative-valued monetary quantity.
  final String negative_sign;
  /// The number of fractional digits to be displayed in an internationally formatted monetary quantity.
  final int int_frac_digits;
  /// The number of fractional digits to be displayed in a formatted monetary quantity.
  final int frac_digits;
  /// Set to 1 or 0 if the currency symbol precedes or succeeds the value for a non-negative formatted monetary quantity.
  final int p_cs_precedes;
  /// Set to a value indicating the separation of the currency symbol, the sign string, and the value for a non-negative formatted monetary quantity.
  final int p_sep_by_space;
  /// Set to 1 or 0 if the currency symbol precedes or succeeds the value for a negative formatted monetary quantity.
  final int n_cs_precedes;
  /// Set to a value indicating the separation of the currency symbol, the sign string, and the value for a negative formatted monetary quantity.
  final int n_sep_by_space;
  /// Set to a value indicating the positioning of the positive_sign for a non-negative formatted monetary quantity.
  final int p_sign_posn;
  /// Set to a value indicating the positioning of the negative_sign for a negative formatted monetary quantity.
  final int n_sign_posn;

  /// Creates a new [Lconv] structure with default "C" locale values.
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
  /// Category for all locale-specific behavior.
  int get LC_ALL => 0;
  /// Category for string collation behavior.
  int get LC_COLLATE => 1;
  /// Category for character classification and case conversion behavior.
  int get LC_CTYPE => 2;
  /// Category for monetary formatting information.
  int get LC_MONETARY => 3;
  /// Category for numeric formatting information.
  int get LC_NUMERIC => 4;
  /// Category for time formatting information.
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

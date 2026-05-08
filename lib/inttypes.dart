// ignore_for_file: camel_case_types
// Extended integer types and formatting (`<inttypes.h>`).

import 'src/stdc_base.dart';
import 'stdint.dart';

/// Represents the return type of `imaxdiv`.
class imaxdiv_t {
  /// The quotient of the division.
  final intmax_t quot;
  
  /// The remainder of the division.
  final intmax_t rem;
  
  /// Creates an [imaxdiv_t] structure with the given [quot] and [rem].
  const imaxdiv_t(this.quot, this.rem);
}

extension IntTypesStdc on Stdc {
  /// Computes the absolute value of an integer `j` of maximum width.
  intmax_t imaxabs(intmax_t j) => j < 0 ? -j : j;
  
  /// Computes both the quotient and remainder of the division of `numer` by `denom`.
  imaxdiv_t imaxdiv(intmax_t numer, intmax_t denom) {
    return imaxdiv_t(numer ~/ denom, numer % denom);
  }

  /// Converts the string `nptr` to an `intmax_t`.
  intmax_t strtoimax(String nptr, {int radix = 10}) {
    return int.parse(nptr, radix: radix);
  }

  /// Converts the string `nptr` to an `uintmax_t`.
  uintmax_t strtoumax(String nptr, {int radix = 10}) {
    return int.parse(nptr, radix: radix);
  }
}

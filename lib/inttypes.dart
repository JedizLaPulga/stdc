// ignore_for_file: camel_case_types
/// `<inttypes.h>` implementation for stdc
///
/// Contains extended integer types and formatting.
library;

import 'src/stdc_base.dart';
import 'stdint.dart';
import 'stdlib.dart';

/// Represents the return type of `imaxdiv`.
class imaxdiv_t {
  /// The quotient of the division.
  final intmax_t quot;
  
  /// The remainder of the division.
  final intmax_t rem;
  
  /// Creates an [imaxdiv_t] structure with the given [quot] and [rem].
  const imaxdiv_t(this.quot, this.rem);
}

/// Extension on [Stdc] to provide `<inttypes.h>` functionality.
extension IntTypesStdc on Stdc {
  /// Computes the absolute value of an integer `j` of maximum width.
  intmax_t imaxabs(intmax_t j) => j < 0 ? -j : j;
  
  /// Computes both the quotient and remainder of the division of `numer` by `denom`.
  imaxdiv_t imaxdiv(intmax_t numer, intmax_t denom) {
    return imaxdiv_t(numer ~/ denom, numer % denom);
  }

  /// Converts the string `nptr` to an `intmax_t`.
  /// 
  /// Trims leading whitespace, handles optional signs, stops at the first invalid
  /// character, and autodetects the radix (base) if `radix` is `0` (e.g. `0x` for 16).
  intmax_t strtoimax(String nptr, {List<String>? endptr, int radix = 10}) {
    return strtoll(nptr, endptr: endptr, radix: radix);
  }

  /// Converts the string `nptr` to an `uintmax_t`.
  /// 
  /// Trims leading whitespace, handles optional signs, stops at the first invalid
  /// character, and autodetects the radix (base) if `radix` is `0` (e.g. `0x` for 16).
  uintmax_t strtoumax(String nptr, {List<String>? endptr, int radix = 10}) {
    return strtoull(nptr, endptr: endptr, radix: radix);
  }
}

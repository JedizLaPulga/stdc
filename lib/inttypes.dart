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

/// Extension on [Stdc] to provide `<inttypes.h>` functionality.
extension IntTypesStdc on Stdc {
  /// Computes the absolute value of an integer `j` of maximum width.
  intmax_t imaxabs(intmax_t j) => j < 0 ? -j : j;
  
  /// Computes both the quotient and remainder of the division of `numer` by `denom`.
  imaxdiv_t imaxdiv(intmax_t numer, intmax_t denom) {
    return imaxdiv_t(numer ~/ denom, numer % denom);
  }

  intmax_t _parseWithCStyle(String nptr, int radix) {
    if (nptr.isEmpty) return 0;
    int i = 0;
    
    // Skip whitespace
    while (i < nptr.length) {
      int c = nptr.codeUnitAt(i);
      if (c == 32 || (c >= 9 && c <= 13)) {
        i++;
      } else {
        break;
      }
    }
    if (i >= nptr.length) return 0;
    
    bool negative = false;
    int c = nptr.codeUnitAt(i);
    if (c == 45) { // '-'
      negative = true;
      i++;
    } else if (c == 43) { // '+'
      i++;
    }
    
    if (i >= nptr.length) return 0;
    
    int actualRadix = radix;
    if (actualRadix == 0) {
      if (nptr.codeUnitAt(i) == 48) { // '0'
        if (i + 1 < nptr.length && (nptr.codeUnitAt(i + 1) == 120 || nptr.codeUnitAt(i + 1) == 88)) {
          actualRadix = 16;
          i += 2;
        } else {
          actualRadix = 8;
          i += 1;
        }
      } else {
        actualRadix = 10;
      }
    } else if (actualRadix == 16) {
      if (nptr.codeUnitAt(i) == 48 && i + 1 < nptr.length && (nptr.codeUnitAt(i + 1) == 120 || nptr.codeUnitAt(i + 1) == 88)) {
        i += 2;
      }
    }
    
    int numStart = i;
    
    // Scan digits
    while (i < nptr.length) {
      c = nptr.codeUnitAt(i);
      int digit = -1;
      if (c >= 48 && c <= 57) { digit = c - 48; }
      else if (c >= 65 && c <= 90) { digit = c - 65 + 10; }
      else if (c >= 97 && c <= 122) { digit = c - 97 + 10; }
      
      if (digit == -1 || digit >= actualRadix) break;
      i++;
    }
    
    if (i == numStart) return 0;
    
    String valStr = nptr.substring(numStart, i);
    String fullStr = (negative ? "-" : "") + valStr;
    
    return int.tryParse(fullStr, radix: actualRadix) ?? 0;
  }

  /// Converts the string `nptr` to an `intmax_t`.
  /// 
  /// Trims leading whitespace, handles optional signs, stops at the first invalid
  /// character, and autodetects the radix (base) if `radix` is `0` (e.g. `0x` for 16).
  intmax_t strtoimax(String nptr, {int radix = 10}) {
    return _parseWithCStyle(nptr, radix);
  }

  /// Converts the string `nptr` to an `uintmax_t`.
  /// 
  /// Trims leading whitespace, handles optional signs, stops at the first invalid
  /// character, and autodetects the radix (base) if `radix` is `0` (e.g. `0x` for 16).
  uintmax_t strtoumax(String nptr, {int radix = 10}) {
    return _parseWithCStyle(nptr, radix);
  }
}

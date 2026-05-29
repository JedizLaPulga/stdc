// ignore_for_file: non_constant_identifier_names, camel_case_types

/// `<stdlib.h>` implementation for stdc
/// 
/// Contains standard utility functions for the `stdc` library.
library;

import 'dart:math' as math;
import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart';
import 'src/stdc_base.dart';

// Internal state for random number generation
math.Random _rand = math.Random();

/// `<stdlib.h>` standard library extensions for `stdc`.
extension StdcStdlib on Stdc {
  // --- String Conversions ---

  /// Converts the string `nptr` to an `int`.
  /// 
  /// Trims leading whitespace, handles optional signs, stops at the first invalid
  /// character, and autodetects the radix (base) if `radix` is `0` (e.g. `0x` for 16).
  /// If [endptr] is provided, `endptr[0]` is set to the unparsed remainder of the string.
  int strtol(String nptr, {List<String>? endptr, int radix = 10}) {
    if (nptr.isEmpty) {
      if (endptr != null && endptr.isNotEmpty) endptr[0] = nptr;
      return 0;
    }
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
    if (i >= nptr.length) {
      if (endptr != null && endptr.isNotEmpty) endptr[0] = nptr;
      return 0;
    }
    
    int start = i;
    bool negative = false;
    int c = nptr.codeUnitAt(i);
    if (c == 45) { // '-'
      negative = true;
      i++;
    } else if (c == 43) { // '+'
      i++;
    }
    
    if (i >= nptr.length) {
      if (endptr != null && endptr.isNotEmpty) endptr[0] = nptr;
      return 0;
    }
    
    int actualRadix = radix;
    if (actualRadix == 0) {
      if (nptr.codeUnitAt(i) == 48) { // '0'
        if (i + 1 < nptr.length && (nptr.codeUnitAt(i + 1) == 120 || nptr.codeUnitAt(i + 1) == 88)) {
          actualRadix = 16;
          i += 2;
        } else {
          actualRadix = 8;
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
    
    if (i == numStart) {
      if (numStart > start && (nptr.codeUnitAt(numStart - 1) == 120 || nptr.codeUnitAt(numStart - 1) == 88)) {
         i = numStart - 1;
         if (endptr != null && endptr.isNotEmpty) {
           endptr[0] = nptr.substring(i);
         }
         return 0;
      }
      
      if (endptr != null && endptr.isNotEmpty) endptr[0] = nptr;
      return 0;
    }
    
    if (endptr != null && endptr.isNotEmpty) {
      endptr[0] = nptr.substring(i);
    }
    
    String valStr = nptr.substring(numStart, i);
    String fullStr = (negative ? "-" : "") + valStr;
    
    return int.tryParse(fullStr, radix: actualRadix) ?? 0;
  }

  /// Alias for [strtol].
  int strtoll(String nptr, {List<String>? endptr, int radix = 10}) => strtol(nptr, endptr: endptr, radix: radix);

  /// Alias for [strtol].
  int strtoul(String nptr, {List<String>? endptr, int radix = 10}) => strtol(nptr, endptr: endptr, radix: radix);

  /// Alias for [strtol].
  int strtoull(String nptr, {List<String>? endptr, int radix = 10}) => strtol(nptr, endptr: endptr, radix: radix);

  /// Converts the string `nptr` to a `double`.
  /// 
  /// Trims leading whitespace, handles optional signs, INF, NAN, and scientific notation.
  /// Stops at the first invalid character.
  /// If [endptr] is provided, `endptr[0]` is set to the unparsed remainder of the string.
  double strtod(String nptr, {List<String>? endptr}) {
    if (nptr.isEmpty) {
      if (endptr != null && endptr.isNotEmpty) endptr[0] = nptr;
      return 0.0;
    }
    int i = 0;
    while (i < nptr.length) {
      int c = nptr.codeUnitAt(i);
      if (c == 32 || (c >= 9 && c <= 13)) {
        i++;
      } else {
        break;
      }
    }
    if (i >= nptr.length) {
      if (endptr != null && endptr.isNotEmpty) endptr[0] = nptr;
      return 0.0;
    }
    
    int start = i;
    bool negative = false;
    int c = nptr.codeUnitAt(i);
    if (c == 45) { // '-'
      negative = true;
      i++;
    } else if (c == 43) { // '+'
      i++;
    }
    
    String upper = nptr.substring(i).toUpperCase();
    if (upper.startsWith("INFINITY")) {
      i += 8;
      if (endptr != null && endptr.isNotEmpty) endptr[0] = nptr.substring(i);
      return negative ? double.negativeInfinity : double.infinity;
    } else if (upper.startsWith("INF")) {
      i += 3;
      if (endptr != null && endptr.isNotEmpty) endptr[0] = nptr.substring(i);
      return negative ? double.negativeInfinity : double.infinity;
    } else if (upper.startsWith("NAN")) {
      i += 3;
      if (endptr != null && endptr.isNotEmpty) endptr[0] = nptr.substring(i);
      return double.nan;
    }

    bool hasDigits = false;
    bool hasDot = false;
    
    while (i < nptr.length) {
      c = nptr.codeUnitAt(i);
      if (c >= 48 && c <= 57) {
        hasDigits = true;
        i++;
      } else if (c == 46 && !hasDot) { // '.'
        hasDot = true;
        i++;
      } else {
        break;
      }
    }
    
    if (!hasDigits) {
      if (endptr != null && endptr.isNotEmpty) endptr[0] = nptr;
      return 0.0;
    }
    
    // Check for exponent
    if (i < nptr.length) {
      c = nptr.codeUnitAt(i);
      if (c == 101 || c == 69) { // 'e' or 'E'
        int expStart = i;
        i++;
        if (i < nptr.length) {
          c = nptr.codeUnitAt(i);
          if (c == 45 || c == 43) i++;
        }
        bool hasExpDigits = false;
        while (i < nptr.length) {
          c = nptr.codeUnitAt(i);
          if (c >= 48 && c <= 57) {
            hasExpDigits = true;
            i++;
          } else {
            break;
          }
        }
        if (!hasExpDigits) {
          i = expStart;
        }
      }
    }
    
    if (endptr != null && endptr.isNotEmpty) {
      endptr[0] = nptr.substring(i);
    }
    
    String valStr = nptr.substring(start, i);
    return double.tryParse(valStr) ?? 0.0;
  }

  /// Alias for [strtod].
  double strtof(String nptr, {List<String>? endptr}) => strtod(nptr, endptr: endptr);

  /// Alias for [strtod].
  double strtold(String nptr, {List<String>? endptr}) => strtod(nptr, endptr: endptr);

  /// Converts a string to an integer, stopping at the first invalid character.
  int atoi(String str) {
    return strtol(str);
  }

  /// Converts a string to a long integer, stopping at the first invalid character.
  int atol(String str) {
    return strtol(str);
  }

  /// Converts a string to a double, stopping at the first invalid character.
  double atof(String str) {
    return strtod(str);
  }

  // --- Pseudo-Random Sequence Generation ---

  /// Seeds the pseudo-random number generator used by [rand].
  void srand(int seed) {
    _rand = math.Random(seed);
  }

  /// Returns a pseudo-random integer between 0 and 0x7FFFFFFF.
  int rand() {
    return _rand.nextInt(0x7FFFFFFF);
  }

  // --- Integer Arithmetic ---

  /// Computes the absolute value of a long integer.
  int labs(int n) => n.abs();

  /// Computes the absolute value of a long long integer.
  int llabs(int n) => n.abs();

  // --- Searching and Sorting ---

  /// Sorts an array (list) using a comparator function.
  /// Modifies the list in-place.
  void qsort<T>(List<T> base, int Function(T a, T b) compar) {
    base.sort(compar);
  }

  /// Performs a binary search on a sorted array (list).
  /// Returns the matching element, or null if not found.
  T? bsearch<T>(T key, List<T> base, int Function(T a, T b) compar) {
    int min = 0;
    int max = base.length - 1;
    while (min <= max) {
      int mid = min + ((max - min) >> 1);
      int cmp = compar(key, base[mid]);
      if (cmp == 0) return base[mid];
      if (cmp < 0) {
        max = mid - 1;
      } else {
        min = mid + 1;
      }
    }
    return null;
  }

  // --- Environment and Process Control ---

  /// Successful termination code.
  int get EXIT_SUCCESS => 0;

  /// Unsuccessful termination code.
  int get EXIT_FAILURE => 1;

  /// Gets an environment variable by [name].
  /// Returns `null` if the variable is not found or if the platform does not support environment variables (e.g., Web).
  String? getenv(String name) {
    return stdlibGetenv(name);
  }

  /// Executes a system command.
  /// Passes the [command] to the system shell and returns the exit code.
  /// Throws `UnsupportedError` on platforms without shell access (e.g., Web).
  int system(String command) {
    return stdlibSystem(command);
  }

  /// Terminates the calling process normally with the given exit [code].
  /// Throws `UnsupportedError` on platforms without process exit support (e.g., Web).
  void exit(int code) {
    stdlibExit(code);
  }

  /// Aborts the current process abnormally.
  /// Maps to `exit(1)` on native platforms and throws `UnsupportedError` on Web.
  void abort() {
    stdlibAbort();
  }
}

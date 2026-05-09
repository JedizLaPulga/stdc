// ignore_for_file: non_constant_identifier_names, camel_case_types
/// `<wchar.h>` implementation for stdc
///
/// Contains wide-character string manipulation functions.
library;

import 'dart:math';
import 'src/stdc_base.dart';
export 'src/stdc_base.dart';

/// Wide character type (maps to a Unicode Rune).
typedef wchar_t = int;

/// Wide integer type.
typedef wint_t = int;

/// Extension on [Stdc] to provide `<wchar.h>` functionality.
extension WcharStdc on Stdc {
  /// Maximum value for a `wchar_t` (Maximum Unicode Code Point).
  int get WCHAR_MAX => 0x10FFFF;
  
  /// Minimum value for a `wchar_t`.
  int get WCHAR_MIN => 0;
  
  /// Wide end-of-file indicator.
  int get WEOF => -1;

  /// Computes the length of the wide string [wcs].
  int wcslen(List<wchar_t> wcs) {
    return wcs.length;
  }

  /// Copies the wide string [src] into [dest].
  /// 
  /// Because Dart lists can be passed by reference, this returns a new 
  /// copied List to avoid unexpected shared state.
  List<wchar_t> wcscpy(List<wchar_t> dest, List<wchar_t> src) {
    return List<wchar_t>.from(src);
  }

  /// Compares the wide string [s1] to the wide string [s2].
  /// Returns 0 if they are equal, a negative value if [s1] is less than [s2],
  /// and a positive value if [s1] is greater than [s2].
  int wcscmp(List<wchar_t> s1, List<wchar_t> s2) {
    int len = min(s1.length, s2.length);
    for (int i = 0; i < len; i++) {
      if (s1[i] != s2[i]) {
        return s1[i] < s2[i] ? -1 : 1;
      }
    }
    if (s1.length < s2.length) return -1;
    if (s1.length > s2.length) return 1;
    return 0;
  }

  /// Appends the wide string [src] to the end of the wide string [dest].
  /// 
  /// Returns the concatenated wide string.
  List<wchar_t> wcscat(List<wchar_t> dest, List<wchar_t> src) {
    return List<wchar_t>.from(dest)..addAll(src);
  }

  /// Finds the first occurrence of the wide character [wc] in the wide string [wcs].
  /// 
  /// Returns the index of the character, or -1 if the character is not found.
  int wcschr(List<wchar_t> wcs, wchar_t wc) {
    return wcs.indexOf(wc);
  }

  /// Finds the first occurrence of the wide substring [needle] in the wide string [haystack].
  /// 
  /// Returns the index of the substring, or -1 if the substring is not found.
  int wcsstr(List<wchar_t> haystack, List<wchar_t> needle) {
    if (needle.isEmpty) return 0;
    for (int i = 0; i <= haystack.length - needle.length; i++) {
      bool match = true;
      for (int j = 0; j < needle.length; j++) {
        if (haystack[i + j] != needle[j]) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }
}

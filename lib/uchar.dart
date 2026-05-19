// ignore_for_file: camel_case_types
/// `<uchar.h>` implementation for stdc
///
/// Contains Unicode utilities.
library;

import 'src/stdc_base.dart';
import 'dart:convert';

/// 16-bit character type used for UTF-16 encoding.
typedef char16_t = int;

/// 32-bit character type used for UTF-32 encoding.
typedef char32_t = int;

/// Extension on [Stdc] to provide `<uchar.h>` functionality.
extension UCharStdc on Stdc {
  /// Converts a UTF-8 encoded sequence to a `char16_t`.
  /// Returns -1 on encoding error.
  char16_t mbrtoc16(List<int> s) {
    if (s.isEmpty) return 0;
    try {
      String str = utf8.decode(s);
      if (str.isEmpty) return 0;
      return str.codeUnitAt(0);
    } catch (_) {
      return -1;
    }
  }

  /// Converts a `char16_t` to a UTF-8 encoded byte sequence.
  List<int> c16rtomb(char16_t c16) {
    String str = String.fromCharCode(c16);
    return utf8.encode(str);
  }
  
  /// Converts a UTF-8 encoded sequence to a `char32_t`.
  /// Returns -1 on encoding error.
  char32_t mbrtoc32(List<int> s) {
    if (s.isEmpty) return 0;
    try {
      String str = utf8.decode(s);
      if (str.isEmpty) return 0;
      return str.runes.first;
    } catch (_) {
      return -1;
    }
  }
  
  /// Converts a `char32_t` to a UTF-8 encoded byte sequence.
  List<int> c32rtomb(char32_t c32) {
    String str = String.fromCharCode(c32);
    return utf8.encode(str);
  }
}

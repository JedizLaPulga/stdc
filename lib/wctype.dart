// ignore_for_file: non_constant_identifier_names, camel_case_types
/// `<wctype.h>` implementation for stdc
/// 
/// Contains wide-character classification and mapping functions.
library;

import 'src/stdc_base.dart';
export 'src/stdc_base.dart';

/// Wide character mapping type.
typedef wctrans_t = int;

/// Wide character classification type.
typedef wctype_t = int;

/// Extension on [Stdc] to provide `<wctype.h>` functionality.
/// 
/// These functions accept a `wint_t` (Rune integer code point) 
/// and perform standard C classifications.
extension WctypeStdc on Stdc {
  /// Checks if the wide character is alphanumeric.
  bool iswalnum(int wc) => iswalpha(wc) || iswdigit(wc);

  /// Checks if the wide character is alphabetic.
  bool iswalpha(int wc) {
    return (wc >= 65 && wc <= 90) || (wc >= 97 && wc <= 122);
  }

  /// Checks if the wide character is a blank character (space or tab).
  bool iswblank(int wc) {
    return wc == 32 || wc == 9;
  }

  /// Checks if the wide character is a control character.
  bool iswcntrl(int wc) {
    return (wc >= 0 && wc <= 31) || wc == 127;
  }

  /// Checks if the wide character is a decimal digit.
  bool iswdigit(int wc) {
    return wc >= 48 && wc <= 57;
  }

  /// Checks if the wide character has a graphical representation.
  bool iswgraph(int wc) {
    return wc >= 33 && wc <= 126;
  }

  /// Checks if the wide character is a lowercase letter.
  bool iswlower(int wc) {
    return wc >= 97 && wc <= 122;
  }

  /// Checks if the wide character is printable.
  bool iswprint(int wc) {
    return wc >= 32 && wc <= 126;
  }

  /// Checks if the wide character is a punctuation character.
  bool iswpunct(int wc) {
    return iswprint(wc) && !iswalnum(wc) && !iswspace(wc);
  }

  /// Checks if the wide character is a white-space character.
  bool iswspace(int wc) {
    return wc == 32 || (wc >= 9 && wc <= 13);
  }

  /// Checks if the wide character is an uppercase letter.
  bool iswupper(int wc) {
    return wc >= 65 && wc <= 90;
  }

  /// Checks if the wide character is a hexadecimal digit.
  bool iswxdigit(int wc) {
    return (wc >= 48 && wc <= 57) || 
           (wc >= 65 && wc <= 70) || 
           (wc >= 97 && wc <= 102);
  }

  /// Converts an uppercase wide character to lowercase.
  int towlower(int wc) {
    if (iswupper(wc)) {
      return wc + 32;
    }
    return wc;
  }

  /// Converts a lowercase wide character to uppercase.
  int towupper(int wc) {
    if (iswlower(wc)) {
      return wc - 32;
    }
    return wc;
  }
}

/// `<ctype.h>` implementation for stdc
/// 
/// Contains standard character classification and mapping functions.
library ctype;

export 'src/stdc_base.dart';
import 'src/stdc_base.dart';

/// Extension on [Stdc] to provide `<ctype.h>` functionality.
/// 
/// Importing this file attaches standard C character handling functions
/// directly to the global `stdc` instance.
/// 
/// Note: Since Dart does not have a `char` type, these functions accept 
/// a `String`. Only the first character (code unit) of the string is evaluated.
extension CtypeStdc on Stdc {
  
  int _getCode(String c) => c.isNotEmpty ? c.codeUnitAt(0) : 0;

  /// Checks if the character is alphanumeric (A-Z, a-z, 0-9).
  bool isalnum(String c) => isalpha(c) || isdigit(c);

  /// Checks if the character is alphabetic (A-Z, a-z).
  bool isalpha(String c) {
    int code = _getCode(c);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }

  /// Checks if the character is a blank character (space or tab).
  bool isblank(String c) {
    int code = _getCode(c);
    return code == 32 || code == 9;
  }

  /// Checks if the character is a control character (0x00-0x1F or 0x7F).
  bool iscntrl(String c) {
    int code = _getCode(c);
    return (code >= 0 && code <= 31) || code == 127;
  }

  /// Checks if the character is a decimal digit (0-9).
  bool isdigit(String c) {
    int code = _getCode(c);
    return code >= 48 && code <= 57;
  }

  /// Checks if the character has a graphical representation (any printable character except space).
  bool isgraph(String c) {
    int code = _getCode(c);
    return code >= 33 && code <= 126;
  }

  /// Checks if the character is a lowercase letter (a-z).
  bool islower(String c) {
    int code = _getCode(c);
    return code >= 97 && code <= 122;
  }

  /// Checks if the character is printable (including space).
  bool isprint(String c) {
    int code = _getCode(c);
    return code >= 32 && code <= 126;
  }

  /// Checks if the character is a punctuation character (printable, not alphanumeric, not space).
  bool ispunct(String c) => isprint(c) && !isalnum(c) && !isspace(c);

  /// Checks if the character is a white-space character.
  /// Standard white-space characters are: space (' '), form feed ('\f'), 
  /// newline ('\n'), carriage return ('\r'), horizontal tab ('\t'), and vertical tab ('\v').
  bool isspace(String c) {
    int code = _getCode(c);
    return code == 32 || (code >= 9 && code <= 13);
  }

  /// Checks if the character is an uppercase letter (A-Z).
  bool isupper(String c) {
    int code = _getCode(c);
    return code >= 65 && code <= 90;
  }

  /// Checks if the character is a hexadecimal digit (0-9, a-f, A-F).
  bool isxdigit(String c) {
    int code = _getCode(c);
    return (code >= 48 && code <= 57) || 
           (code >= 65 && code <= 70) || 
           (code >= 97 && code <= 102);
  }

  /// Converts an uppercase letter to its lowercase equivalent.
  /// If the character is not an uppercase letter, it is returned unchanged.
  String tolower(String c) {
    if (c.isEmpty) return c;
    return c[0].toLowerCase();
  }

  /// Converts a lowercase letter to its uppercase equivalent.
  /// If the character is not a lowercase letter, it is returned unchanged.
  String toupper(String c) {
    if (c.isEmpty) return c;
    return c[0].toUpperCase();
  }
}

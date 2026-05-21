// ignore_for_file: non_constant_identifier_names, camel_case_types

/// `<stdio.h>` implementation for stdc
///
/// Contains standard I/O functions for the `stdc` library.
library;

import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart';
import 'src/stdc_base.dart';
import 'stdarg.dart';
import 'errno.dart';

// ---------------------------------------------------------------------------
// Private formatting helpers used by vsprintf
// ---------------------------------------------------------------------------

bool _fmtIsDigit(String c) {
  final code = c.codeUnitAt(0);
  return code >= 48 && code <= 57;
}

bool _fmtIsWhitespace(String c) =>
    c == ' ' || c == '\t' || c == '\n' || c == '\r';

bool _scanIsRadixDigit(String c, int radix) {
  final code = c.codeUnitAt(0);
  if (radix <= 10) return code >= 48 && code < 48 + radix;
  return (code >= 48 && code <= 57) ||
      (code >= 65 && code < 65 + radix - 10) ||
      (code >= 97 && code < 97 + radix - 10);
}

/// Applies field-width padding to [content].
/// [signAndPrefix] is the leading sign/prefix portion where zeros are inserted
/// when zero-padding (e.g. `"-"` or `"0x"`).
String _fmtPad(
  String content,
  int width,
  bool leftAlign,
  bool zeroPad,
  String signAndPrefix,
) {
  if (width <= 0 || content.length >= width) return content;
  final pad = width - content.length;
  if (leftAlign) return '$content${' ' * pad}';
  if (zeroPad) {
    final sp = signAndPrefix.length;
    return '$signAndPrefix${'0' * pad}${content.substring(sp)}';
  }
  return '${' ' * pad}$content';
}

/// Formats a signed integer [n] in the given [radix].
String _fmtInt(
  int n,
  int radix,
  bool uppercase,
  bool flagMinus,
  bool flagPlus,
  bool flagSpace,
  bool flagZero,
  bool flagHash,
  int width,
  int? precision,
) {
  String sign;
  int absN;
  if (n < 0) {
    sign = '-';
    absN = -n;
  } else if (flagPlus) {
    sign = '+';
    absN = n;
  } else if (flagSpace) {
    sign = ' ';
    absN = n;
  } else {
    sign = '';
    absN = n;
  }

  String digits = absN.toRadixString(radix);
  if (uppercase) digits = digits.toUpperCase();

  bool zeroPad = flagZero;
  if (precision != null) {
    zeroPad = false; // explicit precision overrides zero-padding
    if (digits.length < precision) {
      digits = '${'0' * (precision - digits.length)}$digits';
    }
  }

  String prefix = '';
  if (flagHash && radix == 8 && digits != '0') prefix = '0';
  if (flagHash && radix == 16 && n != 0) prefix = uppercase ? '0X' : '0x';

  final content = '$sign$prefix$digits';
  return _fmtPad(content, width, flagMinus, zeroPad, '$sign$prefix');
}

/// Formats an unsigned integer [n] in the given [radix].
String _fmtUInt(
  int n,
  int radix,
  bool uppercase,
  bool flagMinus,
  bool flagZero,
  bool flagHash,
  int width,
  int? precision,
) {
  String digits = n.toRadixString(radix);
  if (uppercase) digits = digits.toUpperCase();

  bool zeroPad = flagZero;
  if (precision != null) {
    zeroPad = false;
    if (digits.length < precision) {
      digits = '${'0' * (precision - digits.length)}$digits';
    }
  }

  String prefix = '';
  if (flagHash && radix == 8 && digits != '0') prefix = '0';
  if (flagHash && radix == 16 && n != 0) prefix = uppercase ? '0X' : '0x';

  final content = '$prefix$digits';
  return _fmtPad(content, width, flagMinus, zeroPad, prefix);
}

/// Formats a double in fixed-point notation (`%f`).
String _fmtFloat(
  double d,
  int precision,
  bool flagMinus,
  bool flagPlus,
  bool flagSpace,
  bool flagZero,
  bool flagHash,
  int width,
) {
  if (d.isNaN) return _fmtPad('nan', width, flagMinus, false, '');
  String sign;
  double absD;
  if (d.isNegative) {
    sign = '-';
    absD = d.abs();
  } else if (flagPlus) {
    sign = '+';
    absD = d;
  } else if (flagSpace) {
    sign = ' ';
    absD = d;
  } else {
    sign = '';
    absD = d;
  }
  if (d.isInfinite) return _fmtPad('${sign}inf', width, flagMinus, false, '');

  String digits = absD.toStringAsFixed(precision);
  if (flagHash && precision == 0) digits += '.';

  final content = '$sign$digits';
  return _fmtPad(content, width, flagMinus, flagZero, sign);
}

/// Formats a double in scientific notation (`%e`/`%E`).
String _fmtSci(
  double d,
  int precision,
  bool uppercase,
  bool flagMinus,
  bool flagPlus,
  bool flagSpace,
  bool flagZero,
  int width,
) {
  if (d.isNaN) return _fmtPad('nan', width, flagMinus, false, '');
  String sign;
  double absD;
  if (d.isNegative) {
    sign = '-';
    absD = d.abs();
  } else if (flagPlus) {
    sign = '+';
    absD = d;
  } else if (flagSpace) {
    sign = ' ';
    absD = d;
  } else {
    sign = '';
    absD = d;
  }
  if (d.isInfinite) return _fmtPad('${sign}inf', width, flagMinus, false, '');

  // Dart gives e.g. "1.230000e+8"; C requires at least 2 exponent digits.
  final raw = absD.toStringAsExponential(precision);
  final eIdx = raw.indexOf('e');
  final mantissa = raw.substring(0, eIdx);
  final expPart = raw.substring(eIdx + 1); // e.g. "+8" or "-10"
  final expSign = expPart[0];
  final expNum = int.parse(expPart.substring(1)).abs();
  final expStr = expNum.toString().padLeft(2, '0');
  final eChar = uppercase ? 'E' : 'e';

  final digits = '$mantissa$eChar$expSign$expStr';
  final content = '$sign$digits';
  return _fmtPad(content, width, flagMinus, flagZero, sign);
}

/// Formats a double using `%g`/`%G` rules (shorter of `%e`/`%f`).
String _fmtG(
  double d,
  int precision,
  bool uppercase,
  bool flagMinus,
  bool flagPlus,
  bool flagSpace,
  bool flagZero,
  bool flagHash,
  int width,
) {
  if (d.isNaN) return _fmtPad('nan', width, flagMinus, false, '');
  if (d.isInfinite) {
    final sign = d.isNegative ? '-' : (flagPlus ? '+' : (flagSpace ? ' ' : ''));
    return _fmtPad('${sign}inf', width, flagMinus, false, sign);
  }

  // Compute base-10 exponent via Dart's own exponential formatter (avoids log).
  final absD = d.abs();
  int exp = 0;
  if (absD != 0) {
    final expStr = absD.toStringAsExponential(0); // e.g. "1e+5"
    exp = int.parse(expStr.substring(expStr.indexOf('e') + 1));
  }

  String result;
  if (exp < -4 || exp >= precision) {
    result = _fmtSci(
      d,
      precision - 1,
      uppercase,
      false,
      flagPlus,
      flagSpace,
      false,
      0,
    );
  } else {
    final fracDigits = (precision - exp - 1).clamp(0, 20);
    result = _fmtFloat(
      d,
      fracDigits,
      false,
      flagPlus,
      flagSpace,
      false,
      flagHash,
      0,
    );
  }

  // Strip trailing zeros and unnecessary decimal point (unless # flag).
  if (!flagHash) {
    final eIdx = result.indexOf(RegExp(r'[eE]'));
    if (eIdx >= 0) {
      String mantissa = result.substring(0, eIdx);
      final expPart = result.substring(eIdx);
      if (mantissa.contains('.')) {
        mantissa = mantissa.replaceAll(RegExp(r'0+$'), '');
        if (mantissa.endsWith('.')) {
          mantissa = mantissa.substring(0, mantissa.length - 1);
        }
      }
      result = '$mantissa$expPart';
    } else if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'0+$'), '');
      if (result.endsWith('.')) result = result.substring(0, result.length - 1);
    }
  }

  // Extract sign prefix for correct zero-padding placement.
  String signPrefix = '';
  if (result.isNotEmpty &&
      (result[0] == '+' || result[0] == '-' || result[0] == ' ')) {
    signPrefix = result[0];
  }
  return _fmtPad(result, width, flagMinus, flagZero, signPrefix);
}

// ---------------------------------------------------------------------------
// Private scanf helpers
// ---------------------------------------------------------------------------

/// Parses a signed or unsigned integer from [str] at position [si].
/// Returns `(newPosition, value)` or `null` on failure.
(int, int)? _scanInt(String str, int si, int width, int radix, bool signed) {
  final limit = width > 0 ? (si + width).clamp(0, str.length) : str.length;
  int sign = 1;
  if (signed) {
    if (si < limit && str[si] == '-') {
      sign = -1;
      si++;
    } else if (si < limit && str[si] == '+') {
      si++;
    }
  }
  final numStart = si;
  while (si < limit && _scanIsRadixDigit(str[si], radix)) {
    si++;
  }
  if (si == numStart) return null;
  final value = int.tryParse(str.substring(numStart, si), radix: radix);
  if (value == null) return null;
  return (si, sign * value);
}

/// Parses an integer with C `%i` auto-base detection (0x hex, 0 octal, decimal).
(int, int)? _scanIntAuto(String str, int si, int width) {
  final limit = width > 0 ? (si + width).clamp(0, str.length) : str.length;
  int sign = 1;
  if (si < limit && str[si] == '-') {
    sign = -1;
    si++;
  } else if (si < limit && str[si] == '+') {
    si++;
  }
  if (si >= limit) return null;
  int radix = 10;
  if (str[si] == '0') {
    if (si + 1 < limit && (str[si + 1] == 'x' || str[si + 1] == 'X')) {
      radix = 16;
      si += 2;
    } else {
      radix = 8;
    }
  }
  final numStart = si;
  while (si < limit && _scanIsRadixDigit(str[si], radix)) {
    si++;
  }
  if (si == numStart) {
    if (radix == 8 && numStart > 0 && str[numStart - 1] == '0') {
      return (numStart, 0);
    }
    return null;
  }
  final value = int.tryParse(str.substring(numStart, si), radix: radix);
  if (value == null) return null;
  return (si, sign * value);
}

/// Parses a double from [str] at position [si].
(int, double)? _scanDouble(String str, int si, int width) {
  final limit = width > 0 ? (si + width).clamp(0, str.length) : str.length;
  final buf = StringBuffer();
  if (si < limit && (str[si] == '+' || str[si] == '-')) {
    buf.write(str[si++]);
  }
  // nan / inf shorthand
  if (si + 2 < limit) {
    final sub = str.substring(si, si + 3).toLowerCase();
    if (sub == 'nan') return (si + 3, double.nan);
    if (sub == 'inf') {
      final neg = buf.toString() == '-';
      return (si + 3, neg ? double.negativeInfinity : double.infinity);
    }
  }
  while (si < limit && _fmtIsDigit(str[si])) {
    buf.write(str[si++]);
  }
  if (si < limit && str[si] == '.') {
    buf.write(str[si++]);
    while (si < limit && _fmtIsDigit(str[si])) {
      buf.write(str[si++]);
    }
  }
  if (si < limit && (str[si] == 'e' || str[si] == 'E')) {
    buf.write(str[si++]);
    if (si < limit && (str[si] == '+' || str[si] == '-')) buf.write(str[si++]);
    while (si < limit && _fmtIsDigit(str[si])) {
      buf.write(str[si++]);
    }
  }
  final s = buf.toString();
  if (s.isEmpty || s == '+' || s == '-') return null;
  final value = double.tryParse(s);
  if (value == null) return null;
  return (si, value);
}

/// `<stdio.h>` standard I/O extensions for `stdc`.
extension StdcStdio on Stdc {
  // --- Formatted Output ---

  /// Prints formatted output to stdout, returning the number of characters written.
  ///
  /// Supports the full C99 format specifier syntax:
  /// `%[flags][width][.precision][length]specifier`
  ///
  /// **Flags**: `-` (left-align), `+` (force sign), ` ` (space sign),
  /// `0` (zero-pad), `#` (alternate form).
  ///
  /// **Width / Precision**: integer literal or `*` (read from next argument).
  ///
  /// **Specifiers**: `d`, `i`, `u`, `o`, `x`, `X`, `f`, `F`, `e`, `E`,
  /// `g`, `G`, `s`, `c`, `p`, `n`, `%`.
  ///
  /// Example:
  /// ```dart
  /// stdc.printf("%+010.4f\n", [3.14]);  // "+003.1400"
  /// stdc.printf("%-8s|\n", ["hi"]);     // "hi      |"
  /// stdc.printf("%#010x\n", [255]);     // "0x000000ff"
  /// ```
  int printf(String format, [List<dynamic> args = const []]) {
    final ap = va_start(args);
    final result = vprintf(format, ap);
    va_end(ap);
    return result;
  }

  /// Formats arguments into a [String] according to [format].
  ///
  /// Supports the full C99 format specifier syntax — see [printf] for details.
  ///
  /// Example:
  /// ```dart
  /// stdc.sprintf("%05d", [42]);           // "00042"
  /// stdc.sprintf("%.3e", [12345.6789]);   // "1.235e+04"
  /// stdc.sprintf("%-10s|", ["hello"]);    // "hello     |"
  /// ```
  String sprintf(String format, [List<dynamic> args = const []]) {
    final ap = va_start(args);
    final result = vsprintf(format, ap);
    va_end(ap);
    return result;
  }

  /// Prints formatted output to stdout using a [va_list], returning the character count.
  ///
  /// See [printf] for the supported format specifier syntax.
  int vprintf(String format, va_list arg) {
    final result = vsprintf(format, arg);
    stdioWrite(result);
    return result.length;
  }

  /// Formats arguments into a [String] using a [va_list].
  ///
  /// This is the core formatting engine. Supports the full C99 format specifier
  /// syntax: `%[flags][width][.precision][length]specifier`.
  ///
  /// - **Flags**: `-`, `+`, ` `, `0`, `#`
  /// - **Width / Precision**: integer or `*` (next arg)
  /// - **Length modifiers**: `h`, `l`, `ll`, `L`, `z`, `t`, `j` — consumed and
  ///   ignored (Dart integers are always 64-bit)
  /// - **Specifiers**: `d` `i` `u` `o` `x` `X` `f` `F` `e` `E` `g` `G` `s` `c` `p` `n` `%`
  String vsprintf(String format, va_list arg) {
    final buffer = StringBuffer();
    int i = 0;

    while (i < format.length) {
      if (format[i] != '%') {
        buffer.write(format[i++]);
        continue;
      }
      i++; // skip '%'
      if (i >= format.length) break;
      if (format[i] == '%') {
        buffer.write('%');
        i++;
        continue;
      }

      // --- Flags ---
      bool flagMinus = false, flagPlus = false, flagSpace = false;
      bool flagZero = false, flagHash = false;
      bool parsingFlags = true;
      while (parsingFlags && i < format.length) {
        switch (format[i]) {
          case '-':
            flagMinus = true;
            i++;
          case '+':
            flagPlus = true;
            i++;
          case ' ':
            flagSpace = true;
            i++;
          case '0':
            flagZero = true;
            i++;
          case '#':
            flagHash = true;
            i++;
          default:
            parsingFlags = false;
        }
      }

      // --- Width ---
      int width = 0;
      if (i < format.length && format[i] == '*') {
        dynamic wVal;
        try {
          wVal = va_arg<dynamic>(arg);
        } on StateError {
          break;
        }
        width = (wVal as num).toInt();
        if (width < 0) {
          flagMinus = true;
          width = -width;
        }
        i++;
      } else {
        while (i < format.length && _fmtIsDigit(format[i])) {
          width = width * 10 + (format.codeUnitAt(i) - 48);
          i++;
        }
      }

      // --- Precision ---
      int? precision;
      if (i < format.length && format[i] == '.') {
        i++;
        if (i < format.length && format[i] == '*') {
          dynamic pVal;
          try {
            pVal = va_arg<dynamic>(arg);
          } on StateError {
            break;
          }
          final p = (pVal as num).toInt();
          precision = p < 0 ? null : p;
          i++;
        } else {
          precision = 0;
          while (i < format.length && _fmtIsDigit(format[i])) {
            precision = precision! * 10 + (format.codeUnitAt(i) - 48);
            i++;
          }
        }
      }

      // --- Length modifier (consume, ignore) ---
      if (i < format.length) {
        final c = format[i];
        if (c == 'h' ||
            c == 'l' ||
            c == 'L' ||
            c == 'z' ||
            c == 't' ||
            c == 'j') {
          i++;
          if (i < format.length && (format[i] == 'l' || format[i] == 'h')) i++;
        }
      }

      if (i >= format.length) break;
      final spec = format[i++];

      // --- Fetch argument ---
      dynamic argVal;
      if (spec != 'n') {
        try {
          argVal = va_arg<dynamic>(arg);
        } on StateError {
          buffer.write('%$spec');
          continue;
        }
      }

      // --- Format ---
      switch (spec) {
        case 'd':
        case 'i':
          buffer.write(
            _fmtInt(
              (argVal as num).toInt(),
              10,
              false,
              flagMinus,
              flagPlus,
              flagSpace,
              flagZero,
              false,
              width,
              precision,
            ),
          );
        case 'u':
          buffer.write(
            _fmtUInt(
              (argVal as num).toInt(),
              10,
              false,
              flagMinus,
              flagZero,
              false,
              width,
              precision,
            ),
          );
        case 'o':
          buffer.write(
            _fmtUInt(
              (argVal as num).toInt(),
              8,
              false,
              flagMinus,
              flagZero,
              flagHash,
              width,
              precision,
            ),
          );
        case 'x':
          buffer.write(
            _fmtUInt(
              (argVal as num).toInt(),
              16,
              false,
              flagMinus,
              flagZero,
              flagHash,
              width,
              precision,
            ),
          );
        case 'X':
          buffer.write(
            _fmtUInt(
              (argVal as num).toInt(),
              16,
              true,
              flagMinus,
              flagZero,
              flagHash,
              width,
              precision,
            ),
          );
        case 'f':
        case 'F':
          buffer.write(
            _fmtFloat(
              (argVal as num).toDouble(),
              precision ?? 6,
              flagMinus,
              flagPlus,
              flagSpace,
              flagZero,
              flagHash,
              width,
            ),
          );
        case 'e':
          buffer.write(
            _fmtSci(
              (argVal as num).toDouble(),
              precision ?? 6,
              false,
              flagMinus,
              flagPlus,
              flagSpace,
              flagZero,
              width,
            ),
          );
        case 'E':
          buffer.write(
            _fmtSci(
              (argVal as num).toDouble(),
              precision ?? 6,
              true,
              flagMinus,
              flagPlus,
              flagSpace,
              flagZero,
              width,
            ),
          );
        case 'g':
          buffer.write(
            _fmtG(
              (argVal as num).toDouble(),
              precision == 0 ? 1 : (precision ?? 6),
              false,
              flagMinus,
              flagPlus,
              flagSpace,
              flagZero,
              flagHash,
              width,
            ),
          );
        case 'G':
          buffer.write(
            _fmtG(
              (argVal as num).toDouble(),
              precision == 0 ? 1 : (precision ?? 6),
              true,
              flagMinus,
              flagPlus,
              flagSpace,
              flagZero,
              flagHash,
              width,
            ),
          );
        case 's':
          String s = argVal.toString();
          if (precision != null && precision < s.length)
            s = s.substring(0, precision);
          buffer.write(_fmtPad(s, width, flagMinus, false, ''));
        case 'c':
          final ch = argVal is int
              ? String.fromCharCode(argVal)
              : (argVal is String && argVal.isNotEmpty ? argVal[0] : '');
          buffer.write(_fmtPad(ch, width, flagMinus, false, ''));
        case 'p':
          final hex = '0x${identityHashCode(argVal).toRadixString(16)}';
          buffer.write(_fmtPad(hex, width, flagMinus, false, ''));
        case 'n':
          // C writes chars-written count to a pointer; no-op in Dart.
          break;
        default:
          buffer.write('%$spec');
      }
    }

    return buffer.toString();
  }

  /// Writes formatted output to a [String], truncated to at most [n]`-1` characters.
  ///
  /// Mirrors C's `snprintf` size-limit convention (reserves one byte for `\0`).
  /// Returns the (possibly truncated) [String] rather than a character count.
  ///
  /// Deviation from C: returns a [String] directly instead of writing to a buffer.
  ///
  /// Example:
  /// ```dart
  /// stdc.snprintf(6, "Hello, %s!", ["World"]); // "Hello"
  /// stdc.snprintf(20, "%08.3f", [3.14]);        // "0003.140"
  /// ```
  String snprintf(int n, String format, [List<dynamic> args = const []]) {
    if (n <= 0) return '';
    final full = sprintf(format, args);
    return full.length >= n ? full.substring(0, n - 1) : full;
  }

  // --- Formatted Input ---

  /// Parses the string [str] according to [format] and returns matched values.
  ///
  /// This is the string-scanning counterpart to [sprintf]. Each `%` specifier
  /// in [format] consumes one token from [str] and appends the parsed value to
  /// the returned [List]. The list length equals C's integer return value
  /// (number of successfully matched items).
  ///
  /// **Supported specifiers**: `d`, `i` (auto-base), `u`, `o`, `x`/`X`,
  /// `f`/`e`/`g` (all yield `double`), `s` (whitespace-delimited), `c`
  /// (single char as [String]), `n` (chars consumed so far), `%%`.
  ///
  /// **Width modifier**: `%5d` reads at most 5 characters for that field.
  ///
  /// **Suppress-assignment**: `%*d` discards the matched value without
  /// adding it to the result list.
  ///
  /// Deviation from C: values are returned in a [List] instead of being
  /// written through out-pointer arguments.
  ///
  /// Example:
  /// ```dart
  /// final r = stdc.sscanf("42 3.14 hello", "%d %f %s");
  /// // r == [42, 3.14, "hello"]
  ///
  /// final r2 = stdc.sscanf("0xff 010 99", "%i %i %i");
  /// // r2 == [255, 8, 99]  — auto-base detection
  /// ```
  List<dynamic> sscanf(String str, String format) {
    final results = <dynamic>[];
    int si = 0; // position in input string
    int fi = 0; // position in format string

    while (fi < format.length) {
      if (format[fi] == '%') {
        fi++;
        if (fi >= format.length) break;

        // Suppress-assignment flag
        bool suppress = false;
        if (format[fi] == '*') {
          suppress = true;
          fi++;
        }

        // Width
        int width = 0;
        while (fi < format.length && _fmtIsDigit(format[fi])) {
          width = width * 10 + (format.codeUnitAt(fi) - 48);
          fi++;
        }

        // Length modifier (consume, ignore)
        if (fi < format.length) {
          final c = format[fi];
          if (c == 'h' ||
              c == 'l' ||
              c == 'L' ||
              c == 'z' ||
              c == 't' ||
              c == 'j') {
            fi++;
            if (fi < format.length && (format[fi] == 'l' || format[fi] == 'h'))
              fi++;
          }
        }

        if (fi >= format.length) break;
        final spec = format[fi++];

        if (spec == '%') {
          // Match literal '%'
          if (si < str.length && str[si] == '%') si++;
          continue;
        }

        // Skip leading whitespace in input for all specifiers except %c and %n
        if (spec != 'c' && spec != 'n') {
          while (si < str.length && _fmtIsWhitespace(str[si])) si++;
        }

        if (si >= str.length && spec != 'n') break;

        switch (spec) {
          case 'd':
            final m = _scanInt(str, si, width, 10, true);
            if (m == null) return results;
            si = m.$1;
            if (!suppress) results.add(m.$2);
          case 'u':
            final m = _scanInt(str, si, width, 10, false);
            if (m == null) return results;
            si = m.$1;
            if (!suppress) results.add(m.$2);
          case 'i':
            final m = _scanIntAuto(str, si, width);
            if (m == null) return results;
            si = m.$1;
            if (!suppress) results.add(m.$2);
          case 'o':
            final m = _scanInt(str, si, width, 8, false);
            if (m == null) return results;
            si = m.$1;
            if (!suppress) results.add(m.$2);
          case 'x':
          case 'X':
            // Skip optional 0x/0X prefix
            final prefixStart = si;
            if (si + 1 < str.length &&
                str[si] == '0' &&
                (str[si + 1] == 'x' || str[si + 1] == 'X')) {
              si += 2;
            }
            final effectiveWidth = width > 0
                ? (width - (si - prefixStart)).clamp(0, str.length)
                : 0;
            final m = _scanInt(str, si, effectiveWidth, 16, false);
            if (m == null) return results;
            si = m.$1;
            if (!suppress) results.add(m.$2);
          case 'f':
          case 'e':
          case 'E':
          case 'g':
          case 'G':
            final m = _scanDouble(str, si, width);
            if (m == null) return results;
            si = m.$1;
            if (!suppress) results.add(m.$2);
          case 's':
            final start = si;
            int count = 0;
            while (si < str.length &&
                !_fmtIsWhitespace(str[si]) &&
                (width == 0 || count < width)) {
              si++;
              count++;
            }
            if (si == start) return results;
            if (!suppress) results.add(str.substring(start, si));
          case 'c':
            final n = width == 0 ? 1 : width;
            if (si + n > str.length) return results;
            if (!suppress) results.add(str[si]); // single char as String
            si += n;
          case 'n':
            if (!suppress) results.add(si);
          default:
            return results; // unknown specifier — stop
        }
      } else if (_fmtIsWhitespace(format[fi])) {
        // Whitespace in format matches zero or more whitespace in input
        fi++;
        while (si < str.length && _fmtIsWhitespace(str[si])) si++;
      } else {
        // Literal character must match exactly
        if (si < str.length && str[si] == format[fi]) {
          si++;
          fi++;
        } else {
          break;
        }
      }
    }

    return results;
  }

  /// Reads one line from stdin and parses it according to [format].
  ///
  /// Returns a [List] of matched values — see [sscanf] for full documentation.
  ///
  /// Example:
  /// ```dart
  /// // If stdin contains "25 3.8"
  /// final r = stdc.scanf("%d %f");
  /// // r == [25, 3.8]
  /// ```
  List<dynamic> scanf(String format) {
    final line = stdioReadLineSync() ?? '';
    return sscanf(line, format);
  }

  // --- Character & String Output ---

  /// Writes a string to stdout, appended with a newline.
  int puts(String str) {
    stdioWriteln(str);
    return 1; // Returns non-negative value on success
  }

  /// Writes a character to stdout.
  int putchar(int char) {
    stdioWriteCharCode(char);
    return char;
  }

  // --- Input ---

  /// Reads a character from stdin.
  int getchar() {
    final charCode = stdioReadByteSync();
    return charCode;
  }

  /// Reads a line from stdin into a string.
  String? gets() {
    return stdioReadLineSync();
  }

  // --- File I/O ---

  /// End-of-file indicator.
  int get EOF => -1;

  /// Seek from beginning of file.
  int get SEEK_SET => 0;

  /// Seek from current position.
  int get SEEK_CUR => 1;

  /// Seek from end of file.
  int get SEEK_END => 2;

  /// Opens a file.
  ///
  /// The [mode] can be "r", "w", "a", "r+", "w+", "a+" (with or without 'b' for binary).
  FILE? fopen(String filename, String mode) {
    try {
      FileMode fileMode = FileMode.read;
      if (mode.startsWith('r')) {
        fileMode = FileMode.read;
      } else if (mode.startsWith('w')) {
        fileMode = FileMode.write;
      } else if (mode.startsWith('a')) {
        fileMode = FileMode.append;
      }

      final raf = File(filename).openSync(mode: fileMode);
      return FILE._(raf);
    } catch (e) {
      return null;
    }
  }

  /// Closes a file stream.
  int fclose(FILE stream) {
    try {
      stream.close();
      return 0;
    } catch (e) {
      return EOF;
    }
  }

  /// Flushes a file stream.
  int fflush(FILE stream) {
    try {
      stream._raf.flushSync();
      return 0;
    } catch (e) {
      return EOF;
    }
  }

  /// Reads an array of [count] elements, each one with a size of [size] bytes, from the [stream].
  int fread(List<int> ptr, int size, int count, FILE stream) {
    try {
      int bytesToRead = size * count;
      int bytesRead = stream._raf.readIntoSync(ptr, 0, bytesToRead);
      if (bytesRead == 0 && bytesToRead > 0) {
        stream._isEOF = true;
      }
      return bytesRead ~/ size;
    } catch (e) {
      return 0;
    }
  }

  /// Writes an array of [count] elements, each one with a size of [size] bytes, to the [stream].
  int fwrite(List<int> ptr, int size, int count, FILE stream) {
    try {
      int bytesToWrite = size * count;
      stream._raf.writeFromSync(ptr, 0, bytesToWrite);
      return count;
    } catch (e) {
      return 0;
    }
  }

  /// Sets the file position of the [stream] to the given [offset].
  int fseek(FILE stream, int offset, int whence) {
    try {
      int newPos;
      if (whence == SEEK_SET) {
        newPos = offset;
      } else if (whence == SEEK_CUR) {
        newPos = stream._raf.positionSync() + offset;
      } else if (whence == SEEK_END) {
        newPos = stream._raf.lengthSync() + offset;
      } else {
        return -1;
      }
      stream._raf.setPositionSync(newPos);
      stream._isEOF = false;
      return 0;
    } catch (e) {
      return -1;
    }
  }

  /// Returns the current file position of the [stream].
  int ftell(FILE stream) {
    try {
      return stream._raf.positionSync();
    } catch (e) {
      return -1;
    }
  }

  /// Sets the file position of the [stream] to the beginning of the file.
  void rewind(FILE stream) {
    fseek(stream, 0, SEEK_SET);
  }

  /// Tests the end-of-file indicator for the given [stream].
  /// Returns a non-zero value if and only if the end-of-file indicator is set.
  int feof(FILE stream) {
    return stream._isEOF ? 1 : 0;
  }

  /// Writes formatted output to a [stream].
  int fprintf(FILE stream, String format, [List<dynamic> args = const []]) {
    final ap = va_start(args);
    final result = vsprintf(format, ap);
    va_end(ap);

    try {
      stream._raf.writeStringSync(result);
      return result.length;
    } catch (e) {
      return EOF;
    }
  }

  // --- File System Operations ---

  /// Deletes a file.
  int remove(String filename) {
    return ioRemoveSync(filename);
  }

  /// Renames a file.
  int rename(String old_filename, String new_filename) {
    return ioRenameSync(old_filename, new_filename);
  }

  /// Prints an error message to stderr.
  void perror(String s) {
    String errorMsg = 'Error $errno';
    stdioWriteErr('$s: $errorMsg\n');
  }

  /// Generates a valid temporary file name.
  String tmpnam([List<int>? str]) {
    return ioTmpnam(str);
  }

  /// Creates a temporary binary file.
  FILE? tmpfile() {
    final name = ioTmpnam(null);
    final file = fopen(name, 'w+');
    if (file != null) {
      file._isTemp = true;
      file._tempPath = name;
    }
    return file;
  }
}

/// Opaque structure representing a file stream.
class FILE {
  final RandomAccessFile _raf;
  bool _isEOF = false;
  bool _isTemp = false;
  String? _tempPath;

  FILE._(this._raf);

  /// Closes the file stream.
  void close() {
    _raf.closeSync();
    if (_isTemp && _tempPath != null) {
      ioRemoveSync(_tempPath!);
    }
  }
}

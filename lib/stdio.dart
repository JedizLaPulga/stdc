/// `<stdio.h>` implementation for stdc
/// 
/// Contains standard I/O functions for the `stdc` library.
library;

import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart';
import 'src/stdc_base.dart';
import 'stdarg.dart';

/// `<stdio.h>` standard I/O extensions for `stdc`.
extension StdcStdio on Stdc {
  // --- Formatted Output ---

  /// Prints formatted output to stdout.
  /// 
  /// Supports basic C-style format specifiers: `%d`, `%i`, `%s`, `%f`, `%x`, `%X`, `%c`, `%%`.
  int printf(String format, [List<dynamic> args = const []]) {
    final ap = va_start(args);
    final result = vprintf(format, ap);
    va_end(ap);
    return result;
  }

  /// Writes formatted output to a string.
  /// 
  /// Supports basic C-style format specifiers: `%d`, `%i`, `%s`, `%f`, `%x`, `%X`, `%c`, `%%`.
  String sprintf(String format, [List<dynamic> args = const []]) {
    final ap = va_start(args);
    final result = vsprintf(format, ap);
    va_end(ap);
    return result;
  }

  /// Prints formatted output to stdout using a variable argument list.
  int vprintf(String format, va_list arg) {
    final result = vsprintf(format, arg);
    stdioWrite(result);
    return result.length;
  }

  /// Writes formatted output to a string using a variable argument list.
  String vsprintf(String format, va_list arg) {
    final buffer = StringBuffer();
    for (int i = 0; i < format.length; i++) {
      if (format[i] == '%' && i + 1 < format.length) {
        i++;
        String specifier = format[i];
        if (specifier == '%') {
          buffer.write('%');
          continue;
        }

        // Check if there are arguments left without popping yet for the missing arg logic
        // But since va_list is opaque-ish, we should probably handle StateError or peek.
        // Actually, we can just peek internal _index.
        // But to be clean, let's catch StateError or just check.
        // Wait, Dart's standard library doesn't let us peek easily without breaking abstraction,
        // but since they are in the same package, it's fine, though va_arg handles it.
        dynamic argVal;
        try {
          argVal = va_arg<dynamic>(arg);
        } on StateError {
          buffer.write('%$specifier'); // Not enough arguments, just print literally
          continue;
        }

        switch (specifier) {
          case 'd':
          case 'i':
            buffer.write((argVal as num).toInt());
            break;
          case 'f':
            buffer.write((argVal as num).toDouble().toStringAsFixed(6));
            break;
          case 's':
            buffer.write(argVal.toString());
            break;
          case 'c':
            if (argVal is int) {
              buffer.writeCharCode(argVal);
            } else if (argVal is String && argVal.isNotEmpty) {
              buffer.write(argVal[0]);
            }
            break;
          case 'x':
            buffer.write((argVal as int).toRadixString(16).toLowerCase());
            break;
          case 'X':
            buffer.write((argVal as int).toRadixString(16).toUpperCase());
            break;
          default:
            buffer.write('%$specifier'); // Unsupported, print literal
            // We need to revert the arg index because we didn't consume it for a valid specifier.
            // Since we used va_arg, we advanced the index. We must decrement it.
            // In C, standard says behavior is undefined if format is invalid.
            // We'll just decrement it manually for our safe Dart implementation.
            arg.internalRevert();
        }
      } else {
        buffer.write(format[i]);
      }
    }
    return buffer.toString();
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
}

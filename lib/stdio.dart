import 'dart:io';
import 'src/stdc_base.dart';

/// `<stdio.h>` standard I/O extensions for `stdc`.
extension StdcStdio on Stdc {
  // --- Formatted Output ---

  /// Prints formatted output to stdout.
  /// 
  /// Supports basic C-style format specifiers: `%d`, `%i`, `%s`, `%f`, `%x`, `%X`, `%c`, `%%`.
  int printf(String format, [List<dynamic> args = const []]) {
    final result = sprintf(format, args);
    stdout.write(result);
    return result.length;
  }

  /// Writes formatted output to a string.
  /// 
  /// Supports basic C-style format specifiers: `%d`, `%i`, `%s`, `%f`, `%x`, `%X`, `%c`, `%%`.
  String sprintf(String format, [List<dynamic> args = const []]) {
    int argIndex = 0;
    final buffer = StringBuffer();
    for (int i = 0; i < format.length; i++) {
      if (format[i] == '%' && i + 1 < format.length) {
        i++;
        String specifier = format[i];
        if (specifier == '%') {
          buffer.write('%');
          continue;
        }

        if (argIndex >= args.length) {
          buffer.write('%$specifier'); // Not enough arguments, just print literally
          continue;
        }

        var arg = args[argIndex++];
        switch (specifier) {
          case 'd':
          case 'i':
            buffer.write((arg as num).toInt());
            break;
          case 'f':
            buffer.write((arg as num).toDouble().toStringAsFixed(6));
            break;
          case 's':
            buffer.write(arg.toString());
            break;
          case 'c':
            if (arg is int) {
              buffer.writeCharCode(arg);
            } else if (arg is String && arg.isNotEmpty) {
              buffer.write(arg[0]);
            }
            break;
          case 'x':
            buffer.write((arg as int).toRadixString(16).toLowerCase());
            break;
          case 'X':
            buffer.write((arg as int).toRadixString(16).toUpperCase());
            break;
          default:
            buffer.write('%$specifier'); // Unsupported, print literal
            argIndex--; // Revert arg index
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
    stdout.writeln(str);
    return 1; // Returns non-negative value on success
  }

  /// Writes a character to stdout.
  int putchar(int char) {
    stdout.writeCharCode(char);
    return char;
  }

  // --- Input ---

  /// Reads a character from stdin.
  int getchar() {
    final charCode = stdin.readByteSync();
    return charCode;
  }

  /// Reads a line from stdin into a string.
  String? gets() {
    return stdin.readLineSync();
  }
}

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
}

/// Opaque structure representing a file stream.
class FILE {
  final RandomAccessFile _raf;
  bool _isEOF = false;
  
  FILE._(this._raf);

  /// Closes the file stream.
  void close() {
    _raf.closeSync();
  }
}

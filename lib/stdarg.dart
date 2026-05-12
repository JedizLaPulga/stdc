/// `<stdarg.h>` implementation for stdc
/// 
/// Contains standard variadic argument functions for the `stdc` library.
// ignore_for_file: camel_case_types, non_constant_identifier_names
library;

import 'src/stdc_base.dart';

/// Represents a C `va_list` in Dart.
/// 
/// Since Dart does not have raw memory pointers for stack arguments,
/// `va_list` acts as an iterator over a `List<dynamic>`.
class va_list {
  List<dynamic> _args;
  int _index;

  /// Initializes a `va_list` with the given arguments.
  va_list([List<dynamic>? args])
      : _args = args ?? [],
        _index = 0;

  /// Internal method to revert the last `va_arg` operation.
  /// Used by `vsprintf` to handle invalid format specifiers.
  void internalRevert() {
    if (_index > 0) _index--;
  }
}

/// `<stdarg.h>` standard variadic argument extensions for `stdc`.
extension StdcStdarg on Stdc {
  /// Initializes a `va_list` to be used with `va_arg` and `va_end`.
  /// 
  /// In C, this takes the `va_list` and the last known fixed argument.
  /// In Dart, this takes the `List<dynamic>` of variadic arguments
  /// and returns an initialized `va_list`.
  va_list va_start(List<dynamic> args) {
    return va_list(args);
  }

  /// Retrieves the next argument in the `va_list` of the specified type `T`.
  T va_arg<T>(va_list ap) {
    if (ap._index >= ap._args.length) {
      throw StateError('va_arg: no more arguments available in va_list');
    }
    return ap._args[ap._index++] as T;
  }

  /// Cleans up the `va_list`.
  /// 
  /// In Dart, this simply exhausts the internal index.
  void va_end(va_list ap) {
    ap._index = ap._args.length;
  }

  /// Copies the state of the `src` `va_list` to the `dest` `va_list`.
  void va_copy(va_list dest, va_list src) {
    dest._args = List<dynamic>.from(src._args);
    dest._index = src._index;
  }
}

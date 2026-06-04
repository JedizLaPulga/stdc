// ignore_for_file: non_constant_identifier_names, camel_case_types

library;

import 'src/stdc_base.dart';

/// A type representing the environment for a non-local jump.
class jmp_buf {
  final int _id;
  static int _nextId = 0;
  
  /// Creates a new jump buffer environment.
  jmp_buf() : _id = _nextId++;

  @override
  int get hashCode => _id.hashCode;

  @override
  bool operator ==(Object other) => other is jmp_buf && other._id == _id;
}

/// Internal exception thrown by `longjmp`.
class LongJmpException implements Exception {
  /// The target environment marker.
  final jmp_buf env;
  /// The value being passed back.
  final int val;
  
  /// Constructs the jump exception.
  LongJmpException(this.env, this.val);
}

/// Extension providing `setjmp.h` functionality to the `stdc` namespace.
extension SetjmpExtension on Stdc {
  /// Dart-specific adaptation of C's `setjmp`.
  ///
  /// Since Dart does not support returning twice from a function, this adaptation
  /// takes a closure. It executes [body] synchronously.
  /// 
  /// Returns `0` if [body] completes normally, or the integer value provided to
  /// `longjmp` if a non-local jump occurred targeting the provided [env].
  int setjmp(jmp_buf env, void Function() body) {
    try {
      body();
      return 0;
    } on LongJmpException catch (e) {
      if (e.env == env) {
        return e.val == 0 ? 1 : e.val;
      }
      rethrow; // It was meant for a different jmp_buf
    }
  }

  /// Restores the environment saved by the most recent invocation of `setjmp`
  /// in the same thread, with the corresponding [jmp_buf] argument.
  /// 
  /// Does not return. Instead, it unwinds the stack to the matching `setjmp` call.
  Never longjmp(jmp_buf env, int val) {
    throw LongJmpException(env, val);
  }
}

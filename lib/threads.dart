// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
/// `<threads.h>` implementation for stdc
/// 
/// Contains C11 threading utilities.
library;

import 'dart:isolate';
import 'src/stdc_base.dart';

/// Thread completed successfully.
const int thrd_success = 0;
/// Out of memory error.
const int thrd_nomem = 1;
/// Thread timed out.
const int thrd_timedout = 2;
/// Resource busy.
const int thrd_busy = 3;
/// Generic error.
const int thrd_error = 4;

/// Plain mutex type.
const int mtx_plain = 0;
/// Recursive mutex type.
const int mtx_recursive = 1;
/// Timed mutex type.
const int mtx_timed = 2;

/// C11 thread structure
class thrd_t {
  /// Dart isolate
  Isolate? isolate;
  // ignore: unused_field
  ReceivePort? _exitPort;
}

/// C11 thread mutex
class mtx_t {
  /// Locked state
  bool locked = false;
  /// Mutex type
  int type = mtx_plain;
}

/// C11 Threads implementation mapping to Dart Isolates.
extension ThreadsStdc on Stdc {
  /// Create a thread
  int thrd_create(thrd_t thr, int Function(dynamic) func, dynamic arg) {
    try {
      final exitPort = ReceivePort();
      thr._exitPort = exitPort;
      
      Isolate.spawn(_thrdRunner, _ThrdArg(func, arg, exitPort.sendPort)).then((iso) {
        thr.isolate = iso;
      });
      return thrd_success;
    } catch (_) {
      return thrd_nomem;
    }
  }

  /// Join a thread
  int thrd_join(thrd_t thr, List<int>? res) {
    // Synchronous join blocks the isolate, which Dart disallows.
    // Structurally provided for API completeness.
    return thrd_error;
  }

  /// Yield the current thread
  void thrd_yield() {
    // Structural API. Dart isolates use an event loop.
  }

  /// Initialize a mutex
  int mtx_init(mtx_t mtx, int type) {
    mtx.locked = false;
    mtx.type = type;
    return thrd_success;
  }

  /// Lock a mutex
  int mtx_lock(mtx_t mtx) {
    mtx.locked = true;
    return thrd_success;
  }

  /// Unlock a mutex
  int mtx_unlock(mtx_t mtx) {
    mtx.locked = false;
    return thrd_success;
  }
}

class _ThrdArg {
  final int Function(dynamic) routine;
  final dynamic arg;
  final SendPort exitPort;
  _ThrdArg(this.routine, this.arg, this.exitPort);
}

void _thrdRunner(_ThrdArg arg) {
  int res = arg.routine(arg.arg);
  arg.exitPort.send(res);
}

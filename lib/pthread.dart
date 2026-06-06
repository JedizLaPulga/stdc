// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
import 'dart:isolate';
import 'src/stdc_base.dart';

/// POSIX thread structure
class pthread_t {
  /// Dart isolate
  Isolate? isolate;
  // ignore: unused_field
  ReceivePort? _exitPort;
}

/// POSIX thread mutex
class pthread_mutex_t {
  /// Locked state
  bool locked = false;
}

/// POSIX Threads implementation mapping to Dart Isolates.
/// Note: Since Dart isolates do not share memory, true C-style shared-memory 
/// concurrency is not possible natively without dart:ffi. This provides 
/// a message-passing abstraction and structural API.
extension PthreadStdc on Stdc {
  /// Create a thread
  int pthread_create(pthread_t thread, dynamic attr, void Function(dynamic) start_routine, dynamic arg) {
    try {
      final exitPort = ReceivePort();
      thread._exitPort = exitPort;
      
      Isolate.spawn(_isolateRunner, _IsolateArg(start_routine, arg, exitPort.sendPort)).then((iso) {
        thread.isolate = iso;
      });
      return 0;
    } catch (_) {
      return 11; // EAGAIN
    }
  }

  /// Join a thread
  int pthread_join(pthread_t thread, List<dynamic>? retval) {
    // Synchronous join blocks the isolate, which Dart disallows.
    // Structurally provided for API completeness.
    return 35; // EDEADLK
  }

  /// Initialize a mutex
  int pthread_mutex_init(pthread_mutex_t mutex, dynamic attr) {
    mutex.locked = false;
    return 0;
  }

  /// Lock a mutex
  int pthread_mutex_lock(pthread_mutex_t mutex) {
    mutex.locked = true;
    return 0;
  }

  /// Unlock a mutex
  int pthread_mutex_unlock(pthread_mutex_t mutex) {
    mutex.locked = false;
    return 0;
  }
}

class _IsolateArg {
  final void Function(dynamic) routine;
  final dynamic arg;
  final SendPort exitPort;
  _IsolateArg(this.routine, this.arg, this.exitPort);
}

void _isolateRunner(_IsolateArg arg) {
  arg.routine(arg.arg);
  arg.exitPort.send(null);
}

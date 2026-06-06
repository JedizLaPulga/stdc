// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
import 'src/stdc_base.dart';
import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart' as io;

/// POSIX Standard symbolic constants and types
extension UnistdStdc on Stdc {
  /// Suspend execution for an interval of time (in seconds).
  int sleep(int seconds) {
    return io.ioSleep(seconds);
  }

  /// Suspend execution for microsecond intervals.
  int usleep(int microseconds) {
    return io.ioUsleep(microseconds);
  }

  /// Get the process ID.
  int getpid() {
    return io.ioGetpid();
  }

  /// Removes a directory entry. Maps to `remove()`.
  int unlink(String pathname) {
    return io.ioRemoveSync(pathname);
  }

  /// Remove a directory.
  int rmdir(String pathname) {
    try {
      io.Directory(pathname).deleteSync();
      return 0;
    } catch (_) {
      return -1;
    }
  }

  /// Close a file descriptor.
  int close(int fd) {
    return -1;
  }
}

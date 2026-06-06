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
  /// (Since we don't have true integer file descriptors in dart:io that we can reliably manage globally without a complex fd table, we map it conceptually, or throw).
  /// For this abstraction, we will use a global mapping if needed, but for now we define the interface.
  int close(int fd) {
    // In a full implementation, we'd manage an fd table. 
    // We'll leave it as a stub that returns -1 for now.
    return -1;
  }
}

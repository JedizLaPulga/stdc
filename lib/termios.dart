// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
import 'src/stdc_base.dart';
import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart' as io;

/// POSIX terminal I/O structure
class termios {
  /// input modes
  int c_iflag = 0;
  /// output modes
  int c_oflag = 0;
  /// control modes
  int c_cflag = 0;
  /// local modes
  int c_lflag = 0;
}

/// Change attributes immediately
const int TCSANOW = 0;
/// Change attributes when output has drained
const int TCSADRAIN = 1;
/// Change attributes when output has drained; also flush pending input
const int TCSAFLUSH = 2;

/// POSIX Terminal I/O control
extension TermiosStdc on Stdc {
  /// Get the parameters associated with the terminal.
  int tcgetattr(int fd, termios termios_p) {
    if (fd != 0) return -1; // Only stdin supported
    termios_p.c_lflag = io.ioTcgetattr();
    return 0;
  }

  /// Set the parameters associated with the terminal.
  int tcsetattr(int fd, int optional_actions, termios termios_p) {
    if (fd != 0) return -1; // Only stdin supported
    return io.ioTcsetattr(termios_p.c_lflag);
  }
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
import 'src/stdc_base.dart';
import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart' as io;

/// Structure describing the system and machine.
class utsname {
  /// Name of the implementation of the operating system.
  String sysname = '';
  /// Name of this node on the network.
  String nodename = '';
  /// Current release level of the operating system.
  String release = '';
  /// Current version level of the operating system.
  String version = '';
  /// Name of the hardware type on which the system is running.
  String machine = '';
}

/// POSIX System Identification
extension SysUtsnameStdc on Stdc {
  /// Get name and information about current kernel.
  int uname(utsname name) {
    try {
      final info = io.ioUname();
      name.sysname = info['sysname'] ?? '';
      name.nodename = info['nodename'] ?? '';
      name.release = info['release'] ?? '';
      name.version = info['version'] ?? '';
      name.machine = info['machine'] ?? '';
      return 0;
    } catch (_) {
      return -1;
    }
  }
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
import 'src/stdc_base.dart';

/// POSIX file control flags
extension FcntlStdc on Stdc {
  /// Read only flag
  int get O_RDONLY => 0x0000;
  /// Write only flag
  int get O_WRONLY => 0x0001;
  /// Read write flag
  int get O_RDWR   => 0x0002;
  /// Create flag
  int get O_CREAT  => 0x0040;
  /// Exclusive flag
  int get O_EXCL   => 0x0080;
  /// Truncate flag
  int get O_TRUNC  => 0x0200;
  /// Append flag
  int get O_APPEND => 0x0400;
  /// Non-blocking flag
  int get O_NONBLOCK => 0x0800;
  /// Sync flag
  int get O_SYNC   => 0x1000;
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
import 'src/stdc_base.dart';
import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart' as io;

/// Structure to hold file statistics.
class Stat {
  /// Mode of file
  int st_mode = 0;
  /// Size of file
  int st_size = 0;
  /// Access time
  int st_atime = 0;
  /// Modification time
  int st_mtime = 0;
  /// Status change time
  int st_ctime = 0;
}

/// POSIX file status utilities
extension SysStatStdc on Stdc {
  /// Bit mask for the file type bit field
  int get S_IFMT   => 0170000;
  /// Socket
  int get S_IFSOCK => 0140000;
  /// Symbolic link
  int get S_IFLNK  => 0120000;
  /// Regular file
  int get S_IFREG  => 0100000;
  /// Block device
  int get S_IFBLK  => 0060000;
  /// Directory
  int get S_IFDIR  => 0040000;
  /// Character device
  int get S_IFCHR  => 0020000;
  /// FIFO
  int get S_IFIFO  => 0010000;

  /// Read, write, execute/search by owner
  int get S_IRWXU => 00700;
  /// Read permission, owner
  int get S_IRUSR => 00400;
  /// Write permission, owner
  int get S_IWUSR => 00200;
  /// Execute/search permission, owner
  int get S_IXUSR => 00100;

  /// Get file status.
  int stat(String pathname, Stat statbuf) {
    try {
      final stat = io.FileStat.statSync(pathname);
      if (stat.type == io.FileSystemEntityType.notFound) return -1;
      
      statbuf.st_mode = stat.mode;
      statbuf.st_size = stat.size;
      statbuf.st_atime = stat.accessed.millisecondsSinceEpoch ~/ 1000;
      statbuf.st_mtime = stat.modified.millisecondsSinceEpoch ~/ 1000;
      statbuf.st_ctime = stat.changed.millisecondsSinceEpoch ~/ 1000;
      return 0;
    } catch (_) {
      return -1;
    }
  }

  /// Make a directory. Note: `mode` is ignored in Dart's `Directory.createSync`.
  int mkdir(String pathname, int mode) {
    try {
      io.Directory(pathname).createSync();
      return 0;
    } catch (_) {
      return -1;
    }
  }

  /// Change permissions of a file. (Stubbed, as `dart:io` lacks direct synchronous chmod without invoking shell).
  int chmod(String pathname, int mode) {
    return 0; // Stub
  }
}

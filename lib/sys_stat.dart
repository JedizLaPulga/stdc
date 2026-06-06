import 'src/stdc_base.dart';
import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart' as io;

/// Structure to hold file statistics.
class Stat {
  int st_mode = 0;
  int st_size = 0;
  int st_atime = 0;
  int st_mtime = 0;
  int st_ctime = 0;
}

/// POSIX file status utilities
extension SysStatStdc on Stdc {
  int get S_IFMT   => 0170000;
  int get S_IFSOCK => 0140000;
  int get S_IFLNK  => 0120000;
  int get S_IFREG  => 0100000;
  int get S_IFBLK  => 0060000;
  int get S_IFDIR  => 0040000;
  int get S_IFCHR  => 0020000;
  int get S_IFIFO  => 0010000;

  int get S_IRWXU => 00700;
  int get S_IRUSR => 00400;
  int get S_IWUSR => 00200;
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

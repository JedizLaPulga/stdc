// ignore_for_file: non_constant_identifier_names, camel_case_types

library;

import 'src/stdc_base.dart';
import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart';

/// A structure representing a directory entry.
class dirent {
  /// The name of the directory entry.
  final String d_name;
  
  /// Constructs a new directory entry.
  dirent(this.d_name);
}

/// An opaque structure representing a directory stream.
class DIR {
  final String _path;
  Iterator<dynamic>? _iterator;
  bool _isOpen = true;

  DIR._(this._path, this._iterator);
}

/// Extension providing `dirent.h` functionality to the `stdc` namespace.
extension DirentExtension on Stdc {
  /// Opens a directory stream corresponding to the directory [name], and
  /// returns a pointer to the directory stream. On error, returns `null`.
  DIR? opendir(String name) {
    final iterator = ioOpendir(name);
    if (iterator == null) return null;
    return DIR._(name, iterator);
  }

  /// Returns a pointer to a `dirent` representing the next directory entry
  /// in the directory stream pointed to by [dirp]. Returns `null` on reaching
  /// the end of the directory stream or if an error occurred.
  dirent? readdir(DIR? dirp) {
    if (dirp == null || !dirp._isOpen || dirp._iterator == null) return null;
    if (dirp._iterator!.moveNext()) {
      return dirent(ioGetDirentName(dirp._iterator!.current));
    }
    return null;
  }

  /// Closes the directory stream associated with [dirp].
  /// Returns 0 on success. On failure, returns -1.
  int closedir(DIR? dirp) {
    if (dirp == null || !dirp._isOpen) return -1;
    dirp._isOpen = false;
    dirp._iterator = null;
    return 0;
  }

  /// Resets the position of the directory stream [dirp] to the beginning of the directory.
  void rewinddir(DIR? dirp) {
    if (dirp == null || !dirp._isOpen) return;
    dirp._iterator = ioOpendir(dirp._path);
  }
}

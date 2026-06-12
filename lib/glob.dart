// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart';
import 'package:path/path.dart' as p;
import 'src/stdc_base.dart';
import 'fnmatch.dart'; // To use FNM constants

/// Wrapper class for `glob_t` structure.
class glob_t {
  /// Count of paths matched so far.
  int gl_pathc = 0;
  
  /// List of matched pathnames.
  List<String> gl_pathv = [];
  
  /// Slots to reserve at the beginning of gl_pathv.
  int gl_offs = 0;
}

/// Extension providing `<glob.h>` functionality.
extension StdcGlob on Stdc {
  /// Append to the results of a previous call.
  int get GLOB_ERR => 1;
  /// Append a slash to each path which corresponds to a directory.
  int get GLOB_MARK => 2;
  /// Do not sort the returned pathnames.
  int get GLOB_NOSORT => 4;
  /// Insert gl_offs initial null pointers into the list of pathnames.
  int get GLOB_DOOFFS => 8;
  /// If no pattern matches, return the original pattern.
  int get GLOB_NOCHECK => 16;
  /// Append to the results of a previous call to glob().
  int get GLOB_APPEND => 32;
  /// Disable backslash escaping.
  int get GLOB_NOESCAPE => 64;
  
  /// Running out of memory.
  int get GLOB_NOSPACE => 1;
  /// Read error.
  int get GLOB_ABORTED => 2;
  /// No matches found.
  int get GLOB_NOMATCH => 3;

  /// Find pathnames matching a pattern.
  int glob(String pattern, int flags, int Function(String, int)? errfunc, glob_t pglob) {
    if ((flags & GLOB_APPEND) == 0) {
      pglob.gl_pathc = 0;
      pglob.gl_pathv = [];
      if ((flags & GLOB_DOOFFS) != 0) {
        for (int i = 0; i < pglob.gl_offs; i++) {
          pglob.gl_pathv.add(""); // Reserve slots
        }
      }
    }

    try {
      // Simplified pure-Dart glob implementation.
      // This will scan the current directory or the specified directory structure.
      final dirPattern = p.dirname(pattern);
      
      final searchDir = dirPattern == '.' ? Directory.current : Directory(dirPattern);
      if (!searchDir.existsSync()) {
        if ((flags & GLOB_NOCHECK) != 0) {
          pglob.gl_pathv.add(pattern);
          pglob.gl_pathc++;
          return 0;
        }
        return GLOB_NOMATCH;
      }

      int fnmFlags = 0;
      if ((flags & GLOB_NOESCAPE) != 0) fnmFlags |= FNM_NOESCAPE;
      // Usually glob uses FNM_PATHNAME and FNM_PERIOD semantics inherently
      fnmFlags |= FNM_PATHNAME | FNM_PERIOD;

      final entries = searchDir.listSync(recursive: pattern.contains('**'));
      
      int matchCount = 0;
      List<String> matches = [];

      for (var entry in entries) {
        final path = entry.path;
        final relPath = p.relative(path, from: Directory.current.path);
        final toMatch = dirPattern == '.' ? relPath : path;
        
        if (fnmatch(pattern, toMatch, fnmFlags) == 0) {
          String finalPath = toMatch;
          if ((flags & GLOB_MARK) != 0 && entry is Directory) {
            finalPath += '/';
          }
          matches.add(finalPath);
          matchCount++;
        }
      }

      if (matchCount == 0 && (flags & GLOB_NOCHECK) != 0) {
        matches.add(pattern);
        matchCount++;
      }

      if (matchCount == 0) {
        return GLOB_NOMATCH;
      }

      if ((flags & GLOB_NOSORT) == 0) {
        matches.sort();
      }

      pglob.gl_pathv.addAll(matches);
      pglob.gl_pathc += matchCount;

      return 0;
    } catch (e) {
      return GLOB_ABORTED;
    }
  }

  /// Free memory allocated by glob. (In Dart, this just clears the list).
  void globfree(glob_t pglob) {
    pglob.gl_pathc = 0;
    pglob.gl_pathv.clear();
  }
}

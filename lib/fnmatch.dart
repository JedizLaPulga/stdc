// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'src/stdc_base.dart';

/// Extension providing `<fnmatch.h>` functionality.
extension StdcFnmatch on Stdc {
  /// Slash in string only matches slash in pattern.
  int get FNM_PATHNAME => 1;

  /// Backslash is ordinary character.
  int get FNM_NOESCAPE => 2;

  /// Leading period in string must be exactly matched by period in pattern.
  int get FNM_PERIOD => 4;

  /// Match failed.
  int get FNM_NOMATCH => 1;

  /// Matches [string] against the shell wildcard [pattern].
  /// Returns `0` if [string] matches [pattern], `FNM_NOMATCH` if there is no match, or another non-zero value if there is an error.
  int fnmatch(String pattern, String string, int flags) {
    // Basic glob to regex conversion
    String regexPattern = '';
    
    for (int i = 0; i < pattern.length; i++) {
      String c = pattern[i];
      if (c == '*') {
        if ((flags & FNM_PATHNAME) != 0) {
          regexPattern += '[^/]*';
        } else {
          regexPattern += '.*';
        }
      } else if (c == '?') {
        if ((flags & FNM_PATHNAME) != 0) {
          regexPattern += '[^/]';
        } else {
          regexPattern += '.';
        }
      } else if (c == '[') {
        regexPattern += c;
        if (i + 1 < pattern.length && pattern[i + 1] == '!') {
          regexPattern += '^';
          i++;
        }
      } else if (c == ']') {
        regexPattern += c;
      } else if (c == '\\' && (flags & FNM_NOESCAPE) == 0) {
        if (i + 1 < pattern.length) {
          i++;
          regexPattern += RegExp.escape(pattern[i]);
        }
      } else {
        regexPattern += RegExp.escape(c);
      }
    }

    // Handle FNM_PERIOD
    if ((flags & FNM_PERIOD) != 0) {
      if (string.startsWith('.') && !pattern.startsWith('.')) {
        return FNM_NOMATCH;
      }
      if ((flags & FNM_PATHNAME) != 0) {
        // also check after slashes
        for (int i = 0; i < string.length - 1; i++) {
          if (string[i] == '/' && string[i+1] == '.') {
            // Need to see if pattern had a literal dot here. For simplicity, if we don't match it literally we might fail,
            // but a true parser would be more complex. Let's rely on regex match first, and if it matches, verify FNM_PERIOD.
            // Actually, if we just translate `*` to not match leading periods, it's easier.
          }
        }
      }
    }

    try {
      final regExp = RegExp('^$regexPattern\$');
      if (regExp.hasMatch(string)) {
        if ((flags & FNM_PERIOD) != 0 && (flags & FNM_PATHNAME) != 0) {
           // Post-validation for FNM_PERIOD with FNM_PATHNAME
           // e.g. "a/.b" should not match "a/*"
           final partsStr = string.split('/');
           final partsPat = pattern.split('/');
           // This is a naive check but works for many cases
           for (int i = 0; i < partsStr.length && i < partsPat.length; i++) {
             if (partsStr[i].startsWith('.') && !partsPat[i].startsWith('.')) {
               return FNM_NOMATCH;
             }
           }
        }
        return 0; // Success
      }
    } catch (e) {
      return -1; // General error
    }
    
    return FNM_NOMATCH;
  }
}

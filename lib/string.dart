/// `<string.h>` implementation for stdc
/// 
/// Contains standard C string manipulation functions.
library;
export 'src/stdc_base.dart';
import 'dart:math';

import 'src/stdc_base.dart';

/// Extension on [Stdc] to provide `<string.h>` functionality.
/// 
/// Note: Because Dart strings are immutable, functions that traditionally 
/// mutate a buffer in-place (such as `strcpy` or `strcat`) have been adapted 
/// to return the resulting [String]. You must reassign the result to your variable.
extension StringStdc on Stdc {
  
  /// Computes the length of the string [str].
  int strlen(String str) => str.length;

  /// Compares the string [str1] to the string [str2].
  /// Returns 0 if they are equal, a negative value if [str1] is less than [str2],
  /// and a positive value if [str1] is greater than [str2].
  int strcmp(String str1, String str2) => str1.compareTo(str2);

  /// Compares up to [n] characters of the string [str1] to those of the string [str2].
  int strncmp(String str1, String str2, int n) {
    int len1 = min(str1.length, n);
    int len2 = min(str2.length, n);
    String s1 = str1.substring(0, len1);
    String s2 = str2.substring(0, len2);
    return s1.compareTo(s2);
  }

  /// Finds the first occurrence of the character [c] (given as a String) in the string [str].
  /// 
  /// Returns the index of the character, or -1 if the character is not found.
  /// (Deviation from C: Returns an integer index instead of a pointer).
  int strchr(String str, String c) {
    if (c.isEmpty) return -1;
    return str.indexOf(c[0]);
  }

  /// Finds the last occurrence of the character [c] (given as a String) in the string [str].
  /// 
  /// Returns the index of the character, or -1 if the character is not found.
  int strrchr(String str, String c) {
    if (c.isEmpty) return -1;
    return str.lastIndexOf(c[0]);
  }

  /// Finds the first occurrence of the substring [needle] in the string [haystack].
  /// 
  /// Returns the index of the substring, or -1 if the substring is not found.
  int strstr(String haystack, String needle) {
    if (needle.isEmpty) return 0;
    return haystack.indexOf(needle);
  }

  /// Calculates the length of the initial segment of [str1] which consists entirely of characters in [str2].
  int strspn(String str1, String str2) {
    int count = 0;
    for (int i = 0; i < str1.length; i++) {
      if (str2.contains(str1[i])) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// Calculates the length of the initial segment of [str1] which consists entirely of characters not in [str2].
  int strcspn(String str1, String str2) {
    int count = 0;
    for (int i = 0; i < str1.length; i++) {
      if (!str2.contains(str1[i])) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// Finds the first character in the string [str1] that matches any character specified in [str2].
  /// 
  /// Returns the index of the character, or -1 if no such character exists.
  int strpbrk(String str1, String str2) {
    for (int i = 0; i < str1.length; i++) {
      if (str2.contains(str1[i])) {
        return i;
      }
    }
    return -1;
  }

  /// Copies the string [src] into [dest].
  /// 
  /// In C, this mutates the [dest] buffer. Because Dart strings are immutable, 
  /// this function simply returns the [src] string.
  /// 
  /// Example: `dest = stdc.strcpy(dest, src);`
  String strcpy(String dest, String src) {
    return src;
  }

  /// Copies up to [n] characters from the string [src] to [dest].
  /// 
  /// If the length of [src] is less than [n], the remainder of [dest] will be padded with null bytes ('\x00').
  /// Returns the resulting string.
  String strncpy(String dest, String src, int n) {
    if (src.length >= n) {
      return src.substring(0, n);
    } else {
      return src.padRight(n, '\x00');
    }
  }

  /// Appends the string [src] to the end of the string [dest].
  /// 
  /// Returns the concatenated string.
  /// Example: `dest = stdc.strcat(dest, src);`
  String strcat(String dest, String src) {
    return dest + src;
  }

  /// Appends up to [n] characters from the string [src] to the end of the string [dest].
  /// 
  /// Returns the concatenated string.
  String strncat(String dest, String src, int n) {
    if (src.length >= n) {
      return dest + src.substring(0, n);
    } else {
      return dest + src;
    }
  }
}

// ignore_for_file: non_constant_identifier_names

/// `<string.h>` implementation for stdc
/// 
/// Contains standard C string manipulation functions.
library;
export 'src/stdc_base.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';

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

  // --- Mutable Buffer (CString) Functions ---

  /// Copies [n] bytes from the value [c] (converted to an unsigned char) into [dest].
  /// Returns [dest].
  CString memset(CString dest, int c, int n) {
    for (int i = 0; i < n; i++) {
      dest[i] = c & 0xFF;
    }
    return dest;
  }

  /// Copies [n] bytes from memory area [src] to memory area [dest].
  /// Returns [dest].
  CString memcpy(CString dest, CString src, int n) {
    for (int i = 0; i < n; i++) {
      dest[i] = src[i];
    }
    return dest;
  }

  /// Compares the first [n] bytes of [str1] and [str2].
  int memcmp(CString str1, CString str2, int n) {
    for (int i = 0; i < n; i++) {
      if (str1[i] != str2[i]) return str1[i] - str2[i];
    }
    return 0;
  }

  /// Copies the C-string pointed by [src] into the array pointed by [dest], including the terminating null character.
  CString strcpyBuffer(CString dest, CString src) {
    int i = 0;
    while (true) {
      dest[i] = src[i];
      if (src[i] == 0) break;
      i++;
    }
    return dest;
  }

  /// Copies up to [n] characters from the string pointed to, by [src] to [dest].
  CString strncpyBuffer(CString dest, CString src, int n) {
    int i = 0;
    while (i < n && src[i] != 0) {
      dest[i] = src[i];
      i++;
    }
    while (i < n) {
      dest[i] = 0;
      i++;
    }
    return dest;
  }

  /// Appends a copy of the [src] string to the [dest] string.
  CString strcatBuffer(CString dest, CString src) {
    int destLen = strlenBuffer(dest);
    int i = 0;
    while (src[i] != 0) {
      dest[destLen + i] = src[i];
      i++;
    }
    dest[destLen + i] = 0;
    return dest;
  }

  /// Appends up to [n] characters from the string [src] to the end of the string [dest].
  CString strncatBuffer(CString dest, CString src, int n) {
    int destLen = strlenBuffer(dest);
    int i = 0;
    while (i < n && src[i] != 0) {
      dest[destLen + i] = src[i];
      i++;
    }
    dest[destLen + i] = 0;
    return dest;
  }

  /// Computes the length of the string [str].
  int strlenBuffer(CString str) {
    int len = 0;
    while (str[len] != 0) {
      len++;
    }
    return len;
  }

  /// Compares the string [str1] to the string [str2].
  int strcmpBuffer(CString str1, CString str2) {
    int i = 0;
    while (str1[i] != 0 && str1[i] == str2[i]) {
      i++;
    }
    return str1[i] - str2[i];
  }

  /// Tokenizes a string.
  /// 
  /// In C, the first call takes the string, and subsequent calls take `null`.
  /// We simulate this by accepting a nullable string. If [str] is provided,
  /// tokenization starts fresh. If [str] is null, tokenization continues from
  /// the last saved state.
  String? strtok(String? str, String delim) {
    if (str != null) {
      _strtokState = str;
    }
    
    if (_strtokState == null || _strtokState!.isEmpty) {
      return null;
    }
    
    // Skip leading delimiters
    int start = 0;
    while (start < _strtokState!.length && delim.contains(_strtokState![start])) {
      start++;
    }
    
    if (start >= _strtokState!.length) {
      _strtokState = null;
      return null;
    }
    
    // Find end of token
    int end = start;
    while (end < _strtokState!.length && !delim.contains(_strtokState![end])) {
      end++;
    }
    
    String token = _strtokState!.substring(start, end);
    
    // Save remaining state
    if (end < _strtokState!.length) {
      // Find the next non-delimiter or just save from end. 
      // C strtok replaces the delimiter with \0 and advances the pointer.
      // So the next strtok continues from end+1. But if end+1 is a delimiter,
      // the next strtok call will skip it.
      _strtokState = _strtokState!.substring(end + 1);
    } else {
      _strtokState = null;
    }
    
    return token;
  }

  /// Reentrant string tokenization.
  /// 
  /// Because Dart does not have out-parameters, we simulate `saveptr` by
  /// passing a [List<String>] of length 1 to hold the state.
  /// Example: `List<String> state = [""]; strtok_r(str, delim, state);`
  String? strtok_r(String? str, String delim, List<String> saveptr) {
    if (saveptr.isEmpty) saveptr.add("");
    
    String state;
    if (str != null) {
      state = str;
    } else {
      if (saveptr[0].isEmpty) return null;
      state = saveptr[0];
    }
    
    int start = 0;
    while (start < state.length && delim.contains(state[start])) {
      start++;
    }
    
    if (start >= state.length) {
      saveptr[0] = "";
      return null;
    }
    
    int end = start;
    while (end < state.length && !delim.contains(state[end])) {
      end++;
    }
    
    String token = state.substring(start, end);
    
    if (end < state.length) {
      saveptr[0] = state.substring(end + 1);
    } else {
      saveptr[0] = "";
    }
    
    return token;
  }
}

String? _strtokState;

/// Represents a mutable C-style string buffer (char array).
class CString {
  final Uint8List _data;

  /// Allocates a zero-initialized buffer of [size] bytes.
  CString.allocate(int size) : _data = Uint8List(size);

  /// Allocates a buffer containing the UTF-8 representation of [s], plus a null terminator.
  CString.fromString(String s) : _data = _stringToBytes(s);

  static Uint8List _stringToBytes(String s) {
    final encoded = utf8.encode(s);
    final result = Uint8List(encoded.length + 1);
    result.setRange(0, encoded.length, encoded);
    result[encoded.length] = 0; // null terminator
    return result;
  }

  /// Reads a byte at [index].
  int operator [](int index) => _data[index];

  /// Writes a byte at [index].
  void operator []=(int index, int value) => _data[index] = value;

  /// Converts the buffer up to the first null terminator into a Dart String.
  @override
  String toString() {
    int len = 0;
    while (len < _data.length && _data[len] != 0) {
      len++;
    }
    return utf8.decode(_data.sublist(0, len), allowMalformed: true);
  }
}

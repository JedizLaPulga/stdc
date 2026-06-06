// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
import 'src/stdc_base.dart';

/// POSIX regular expression
class regex_t {
  /// Dart RegExp object
  RegExp? re;
  /// Compilation flags
  int cflags = 0;
}

/// POSIX regular expression match
class regmatch_t {
  /// Start offset
  int rm_so = -1;
  /// End offset
  int rm_eo = -1;
}

/// POSIX regular expression operations
extension RegexStdc on Stdc {
  /// Extended regex
  int get REG_EXTENDED => 1;
  /// Ignore case
  int get REG_ICASE => 2;
  /// No sub matches
  int get REG_NOSUB => 4;
  /// Match newlines
  int get REG_NEWLINE => 8;

  /// Not beginning of line
  int get REG_NOTBOL => 1;
  /// Not end of line
  int get REG_NOTEOL => 2;

  /// No match found
  int get REG_NOMATCH => 1;
  /// Bad pattern
  int get REG_BADPAT => 2;

  /// Compile regex
  int regcomp(regex_t preg, String regex, int cflags) {
    try {
      bool caseSensitive = (cflags & REG_ICASE) == 0;
      bool multiLine = (cflags & REG_NEWLINE) != 0;
      preg.re = RegExp(regex, caseSensitive: caseSensitive, multiLine: multiLine);
      preg.cflags = cflags;
      return 0;
    } catch (_) {
      return REG_BADPAT;
    }
  }

  /// Execute regex match
  int regexec(regex_t preg, String string, int nmatch, List<regmatch_t> pmatch, int eflags) {
    if (preg.re == null) return REG_BADPAT;
    
    var match = preg.re!.firstMatch(string);
    if (match == null) return REG_NOMATCH;

    if ((preg.cflags & REG_NOSUB) == 0 && nmatch > 0 && pmatch.isNotEmpty) {
      pmatch[0].rm_so = match.start;
      pmatch[0].rm_eo = match.end;
    }
    return 0;
  }

  /// Free regex resources
  void regfree(regex_t preg) {
    preg.re = null;
  }

  /// Get regex error string
  int regerror(int errcode, regex_t preg, List<int> errbuf, int errbuf_size) {
    return 0;
  }
}

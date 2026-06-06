import 'src/stdc_base.dart';

class regex_t {
  RegExp? re;
  int cflags = 0;
}

class regmatch_t {
  int rm_so = -1;
  int rm_eo = -1;
}

extension RegexStdc on Stdc {
  int get REG_EXTENDED => 1;
  int get REG_ICASE => 2;
  int get REG_NOSUB => 4;
  int get REG_NEWLINE => 8;

  int get REG_NOTBOL => 1;
  int get REG_NOTEOL => 2;

  int get REG_NOMATCH => 1;
  int get REG_BADPAT => 2;

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

  void regfree(regex_t preg) {
    preg.re = null;
  }

  int regerror(int errcode, regex_t preg, List<int> errbuf, int errbuf_size) {
    return 0;
  }
}

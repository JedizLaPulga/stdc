import 'package:stdc/stdc.dart' hide group;
import 'package:test/test.dart';

void main() {
  group('<fnmatch.h>', () {
    test('basic matching', () {
      expect(stdc.fnmatch("*.txt", "hello.txt", 0), equals(0));
      expect(stdc.fnmatch("*.txt", "hello.c", 0), equals(stdc.FNM_NOMATCH));
      expect(stdc.fnmatch("file?.txt", "file1.txt", 0), equals(0));
      expect(stdc.fnmatch("file?.txt", "file10.txt", 0), equals(stdc.FNM_NOMATCH));
    });

    test('character classes', () {
      expect(stdc.fnmatch("file[0-9].txt", "file5.txt", 0), equals(0));
      expect(stdc.fnmatch("file[0-9].txt", "fileA.txt", 0), equals(stdc.FNM_NOMATCH));
      expect(stdc.fnmatch("file[!0-9].txt", "fileA.txt", 0), equals(0));
    });

    test('FNM_PATHNAME', () {
      // Without FNM_PATHNAME, * matches /
      expect(stdc.fnmatch("a*b", "a/b", 0), equals(0));
      // With FNM_PATHNAME, * does not match /
      expect(stdc.fnmatch("a*b", "a/b", stdc.FNM_PATHNAME), equals(stdc.FNM_NOMATCH));
      expect(stdc.fnmatch("a/*", "a/b", stdc.FNM_PATHNAME), equals(0));
    });

    test('FNM_PERIOD', () {
      // Without FNM_PERIOD, * matches leading period
      expect(stdc.fnmatch("*", ".hidden", 0), equals(0));
      // With FNM_PERIOD, * does not match leading period
      expect(stdc.fnmatch("*", ".hidden", stdc.FNM_PERIOD), equals(stdc.FNM_NOMATCH));
      expect(stdc.fnmatch(".*", ".hidden", stdc.FNM_PERIOD), equals(0));
    });
  });
}

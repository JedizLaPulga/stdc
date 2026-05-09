import 'package:test/test.dart';
import 'package:stdc/stdc.dart';

void main() {
  group('wchar.h', () {
    test('WCHAR macros should be defined', () {
      expect(stdc.WCHAR_MAX, equals(0x10FFFF));
      expect(stdc.WCHAR_MIN, equals(0));
      expect(stdc.WEOF, equals(-1));
    });

    test('wcslen should return length of wide string', () {
      List<wchar_t> wcs = [104, 101, 108, 108, 111]; // "hello"
      expect(stdc.wcslen(wcs), equals(5));
      expect(stdc.wcslen([]), equals(0));
    });

    test('wcscpy should copy wide string', () {
      List<wchar_t> src = [104, 101, 108, 108, 111];
      List<wchar_t> dest = stdc.wcscpy([], src);
      expect(dest, equals(src));
      expect(identical(dest, src), isFalse); // Ensure it's a new instance
    });

    test('wcscmp should compare wide strings', () {
      List<wchar_t> a = [97, 98, 99]; // "abc"
      List<wchar_t> b = [97, 98, 99]; // "abc"
      List<wchar_t> c = [97, 98, 100]; // "abd"
      List<wchar_t> d = [97, 98]; // "ab"
      
      expect(stdc.wcscmp(a, b), equals(0));
      expect(stdc.wcscmp(a, c), lessThan(0));
      expect(stdc.wcscmp(c, a), greaterThan(0));
      expect(stdc.wcscmp(a, d), greaterThan(0));
      expect(stdc.wcscmp(d, a), lessThan(0));
    });

    test('wcscat should concatenate wide strings', () {
      List<wchar_t> dest = [104, 101]; // "he"
      List<wchar_t> src = [108, 108, 111]; // "llo"
      List<wchar_t> result = stdc.wcscat(dest, src);
      expect(result, equals([104, 101, 108, 108, 111]));
    });

    test('wcschr should find first occurrence of wide character', () {
      List<wchar_t> wcs = [104, 101, 108, 108, 111];
      expect(stdc.wcschr(wcs, 108), equals(2));
      expect(stdc.wcschr(wcs, 120), equals(-1));
    });

    test('wcsstr should find first occurrence of wide substring', () {
      List<wchar_t> haystack = [104, 101, 108, 108, 111];
      List<wchar_t> needle1 = [108, 108];
      List<wchar_t> needle2 = [111];
      List<wchar_t> needle3 = [120];
      
      expect(stdc.wcsstr(haystack, needle1), equals(2));
      expect(stdc.wcsstr(haystack, needle2), equals(4));
      expect(stdc.wcsstr(haystack, needle3), equals(-1));
      expect(stdc.wcsstr(haystack, []), equals(0));
    });
  });
}

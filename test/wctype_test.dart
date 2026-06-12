import 'package:test/test.dart';
import 'package:stdc/stdc.dart' hide group;

void main() {
  group('wctype.h', () {
    test('iswalnum should identify alphanumeric wide characters', () {
      expect(stdc.iswalnum(65), isTrue); // 'A'
      expect(stdc.iswalnum(97), isTrue); // 'a'
      expect(stdc.iswalnum(48), isTrue); // '0'
      expect(stdc.iswalnum(32), isFalse); // ' '
    });

    test('iswalpha should identify alphabetic wide characters', () {
      expect(stdc.iswalpha(65), isTrue); // 'A'
      expect(stdc.iswalpha(97), isTrue); // 'a'
      expect(stdc.iswalpha(48), isFalse); // '0'
    });

    test('iswblank should identify space or tab', () {
      expect(stdc.iswblank(32), isTrue); // ' '
      expect(stdc.iswblank(9), isTrue); // '\t'
      expect(stdc.iswblank(65), isFalse); // 'A'
    });

    test('iswcntrl should identify control characters', () {
      expect(stdc.iswcntrl(10), isTrue); // '\n'
      expect(stdc.iswcntrl(31), isTrue);
      expect(stdc.iswcntrl(127), isTrue); // DEL
      expect(stdc.iswcntrl(65), isFalse); // 'A'
    });

    test('iswdigit should identify decimal digits', () {
      expect(stdc.iswdigit(48), isTrue); // '0'
      expect(stdc.iswdigit(57), isTrue); // '9'
      expect(stdc.iswdigit(65), isFalse); // 'A'
    });

    test('iswgraph should identify characters with graphical representation', () {
      expect(stdc.iswgraph(33), isTrue); // '!'
      expect(stdc.iswgraph(126), isTrue); // '~'
      expect(stdc.iswgraph(32), isFalse); // ' '
    });

    test('iswlower should identify lowercase letters', () {
      expect(stdc.iswlower(97), isTrue); // 'a'
      expect(stdc.iswlower(122), isTrue); // 'z'
      expect(stdc.iswlower(65), isFalse); // 'A'
    });

    test('iswprint should identify printable characters', () {
      expect(stdc.iswprint(32), isTrue); // ' '
      expect(stdc.iswprint(126), isTrue); // '~'
      expect(stdc.iswprint(10), isFalse); // '\n'
    });

    test('iswpunct should identify punctuation characters', () {
      expect(stdc.iswpunct(33), isTrue); // '!'
      expect(stdc.iswpunct(46), isTrue); // '.'
      expect(stdc.iswpunct(65), isFalse); // 'A'
      expect(stdc.iswpunct(32), isFalse); // ' '
    });

    test('iswspace should identify white-space characters', () {
      expect(stdc.iswspace(32), isTrue); // ' '
      expect(stdc.iswspace(10), isTrue); // '\n'
      expect(stdc.iswspace(13), isTrue); // '\r'
      expect(stdc.iswspace(65), isFalse); // 'A'
    });

    test('iswupper should identify uppercase letters', () {
      expect(stdc.iswupper(65), isTrue); // 'A'
      expect(stdc.iswupper(90), isTrue); // 'Z'
      expect(stdc.iswupper(97), isFalse); // 'a'
    });

    test('iswxdigit should identify hexadecimal digits', () {
      expect(stdc.iswxdigit(48), isTrue); // '0'
      expect(stdc.iswxdigit(65), isTrue); // 'A'
      expect(stdc.iswxdigit(102), isTrue); // 'f'
      expect(stdc.iswxdigit(103), isFalse); // 'g'
    });

    test('towlower should convert to lowercase', () {
      expect(stdc.towlower(65), equals(97)); // 'A' -> 'a'
      expect(stdc.towlower(97), equals(97)); // 'a' -> 'a'
      expect(stdc.towlower(33), equals(33)); // '!' -> '!'
    });

    test('towupper should convert to uppercase', () {
      expect(stdc.towupper(97), equals(65)); // 'a' -> 'A'
      expect(stdc.towupper(65), equals(65)); // 'A' -> 'A'
      expect(stdc.towupper(33), equals(33)); // '!' -> '!'
    });
  });
}

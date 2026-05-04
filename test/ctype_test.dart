import 'package:stdc/ctype.dart';
import 'package:test/test.dart';

void main() {
  group('ctype.h', () {
    test('isalpha', () {
      expect(stdc.isalpha('A'), isTrue);
      expect(stdc.isalpha('z'), isTrue);
      expect(stdc.isalpha('5'), isFalse);
      expect(stdc.isalpha(' '), isFalse);
      expect(stdc.isalpha(''), isFalse);
    });

    test('isdigit', () {
      expect(stdc.isdigit('0'), isTrue);
      expect(stdc.isdigit('9'), isTrue);
      expect(stdc.isdigit('a'), isFalse);
    });

    test('isalnum', () {
      expect(stdc.isalnum('A'), isTrue);
      expect(stdc.isalnum('9'), isTrue);
      expect(stdc.isalnum('-'), isFalse);
    });

    test('isspace', () {
      expect(stdc.isspace(' '), isTrue);
      expect(stdc.isspace('\n'), isTrue);
      expect(stdc.isspace('\t'), isTrue);
      expect(stdc.isspace('A'), isFalse);
    });

    test('isxdigit', () {
      expect(stdc.isxdigit('0'), isTrue);
      expect(stdc.isxdigit('f'), isTrue);
      expect(stdc.isxdigit('F'), isTrue);
      expect(stdc.isxdigit('g'), isFalse);
    });

    test('toupper and tolower', () {
      expect(stdc.toupper('a'), equals('A'));
      expect(stdc.toupper('A'), equals('A'));
      expect(stdc.toupper('5'), equals('5'));

      expect(stdc.tolower('A'), equals('a'));
      expect(stdc.tolower('a'), equals('a'));
      expect(stdc.tolower('!'), equals('!'));
    });
    
    test('islower and isupper', () {
      expect(stdc.islower('a'), isTrue);
      expect(stdc.islower('A'), isFalse);
      expect(stdc.isupper('A'), isTrue);
      expect(stdc.isupper('a'), isFalse);
    });
    
    test('isblank', () {
      expect(stdc.isblank(' '), isTrue);
      expect(stdc.isblank('\t'), isTrue);
      expect(stdc.isblank('\n'), isFalse);
    });
    
    test('iscntrl', () {
      expect(stdc.iscntrl('\n'), isTrue);
      expect(stdc.iscntrl('\t'), isTrue);
      expect(stdc.iscntrl('A'), isFalse);
    });
    
    test('isgraph', () {
      expect(stdc.isgraph('A'), isTrue);
      expect(stdc.isgraph('!'), isTrue);
      expect(stdc.isgraph(' '), isFalse);
    });
    
    test('isprint', () {
      expect(stdc.isprint('A'), isTrue);
      expect(stdc.isprint('!'), isTrue);
      expect(stdc.isprint(' '), isTrue);
      expect(stdc.isprint('\n'), isFalse);
    });
    
    test('ispunct', () {
      expect(stdc.ispunct('!'), isTrue);
      expect(stdc.ispunct(','), isTrue);
      expect(stdc.ispunct('A'), isFalse);
      expect(stdc.ispunct('1'), isFalse);
      expect(stdc.ispunct(' '), isFalse);
    });
  });
}

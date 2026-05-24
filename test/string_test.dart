import 'package:stdc/string.dart';
import 'package:test/test.dart';

void main() {
  group('string.h', () {
    test('strlen', () {
      expect(stdc.strlen('hello'), equals(5));
      expect(stdc.strlen(''), equals(0));
    });

    test('strcmp', () {
      expect(stdc.strcmp('a', 'a'), equals(0));
      expect(stdc.strcmp('a', 'b'), lessThan(0));
      expect(stdc.strcmp('b', 'a'), greaterThan(0));
    });

    test('strncmp', () {
      expect(stdc.strncmp('hello', 'help', 3), equals(0));
      expect(stdc.strncmp('hello', 'help', 4), lessThan(0));
      expect(stdc.strncmp('help', 'hello', 4), greaterThan(0));
    });

    test('strchr', () {
      expect(stdc.strchr('hello', 'l'), equals(2));
      expect(stdc.strchr('hello', 'z'), equals(-1));
      expect(stdc.strchr('hello', ''), equals(-1));
    });

    test('strrchr', () {
      expect(stdc.strrchr('hello', 'l'), equals(3));
      expect(stdc.strrchr('hello', 'z'), equals(-1));
    });

    test('strstr', () {
      expect(stdc.strstr('hello world', 'world'), equals(6));
      expect(stdc.strstr('hello world', 'z'), equals(-1));
      expect(stdc.strstr('hello', ''), equals(0));
    });

    test('strspn', () {
      expect(stdc.strspn('hello', 'he'), equals(2));
      expect(stdc.strspn('hello', 'z'), equals(0));
      expect(stdc.strspn('12345abc', '1234567890'), equals(5));
    });

    test('strcspn', () {
      expect(stdc.strcspn('hello', 'l'), equals(2));
      expect(stdc.strcspn('hello', 'z'), equals(5));
      expect(stdc.strcspn('abc12345', '1234567890'), equals(3));
    });

    test('strpbrk', () {
      expect(stdc.strpbrk('hello', 'lo'), equals(2)); // 'l' is at index 2
      expect(stdc.strpbrk('hello', 'z'), equals(-1));
    });

    test('strcpy', () {
      String dest = "world";
      String src = "hello";
      dest = stdc.strcpy(dest, src);
      expect(dest, equals("hello"));
    });

    test('strncpy', () {
      String dest = "world123";
      String src = "hello";
      dest = stdc.strncpy(dest, src, 3);
      expect(dest, equals("hel"));

      dest = "world123";
      dest = stdc.strncpy(dest, src, 7);
      expect(dest, equals("hello\x00\x00"));
    });

    test('strcat', () {
      String dest = "hello";
      String src = " world";
      dest = stdc.strcat(dest, src);
      expect(dest, equals("hello world"));
    });

    test('strncat', () {
      String dest = "hello";
      String src = " world";
      dest = stdc.strncat(dest, src, 3);
      expect(dest, equals("hello wo"));
      
      dest = "hello";
      dest = stdc.strncat(dest, src, 10);
      expect(dest, equals("hello world"));
    });
  });

  group('CString (Mutable Buffers)', () {
    test('Allocation and conversion', () {
      var cstr = CString.allocate(5);
      expect(cstr[0], equals(0));
      cstr[0] = 65; // 'A'
      expect(cstr.toString(), equals('A'));

      var fromStr = CString.fromString('hello');
      expect(fromStr.toString(), equals('hello'));
      expect(fromStr[5], equals(0)); // null terminator
    });

    test('memset and memcpy', () {
      var dest = CString.allocate(5);
      stdc.memset(dest, 65, 3);
      expect(dest[0], equals(65));
      expect(dest[1], equals(65));
      expect(dest[2], equals(65));
      expect(dest[3], equals(0));

      var src = CString.fromString('xyz');
      stdc.memcpy(dest, src, 3);
      expect(dest.toString(), equals('xyz'));
    });

    test('memcmp', () {
      var str1 = CString.fromString('abc');
      var str2 = CString.fromString('abd');
      expect(stdc.memcmp(str1, str2, 2), equals(0));
      expect(stdc.memcmp(str1, str2, 3), lessThan(0));
    });

    test('strcpyBuffer and strncpyBuffer', () {
      var dest = CString.allocate(10);
      var src = CString.fromString('hello');
      stdc.strcpyBuffer(dest, src);
      expect(dest.toString(), equals('hello'));

      stdc.strncpyBuffer(dest, CString.fromString('world123'), 3);
      expect(dest.toString(), equals('worlo')); // 'lo' remains from 'hello'
    });

    test('strcatBuffer and strncatBuffer', () {
      var dest = CString.allocate(20);
      stdc.strcpyBuffer(dest, CString.fromString('hello'));
      stdc.strcatBuffer(dest, CString.fromString(' world'));
      expect(dest.toString(), equals('hello world'));

      stdc.strncatBuffer(dest, CString.fromString('!!!'), 2);
      expect(dest.toString(), equals('hello world!!'));
    });

    test('strlenBuffer and strcmpBuffer', () {
      var str = CString.fromString('hello');
      expect(stdc.strlenBuffer(str), equals(5));

      var str2 = CString.fromString('help');
      expect(stdc.strcmpBuffer(str, str), equals(0));
      expect(stdc.strcmpBuffer(str, str2), lessThan(0));
    });
  });
}

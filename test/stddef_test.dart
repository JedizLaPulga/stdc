import 'package:test/test.dart';
import 'package:stdc/stdc.dart' hide group;

void main() {
  group('stddef.h', () {
    test('types', () {
      size_t s = 10;
      ptrdiff_t p = -5;
      
      expect(s, 10);
      expect(p, -5);
    });

    test('NULL', () {
      expect(stdc.NULL, null);
    });
  });
}

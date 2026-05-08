import 'package:test/test.dart';
import 'package:stdc/stdc.dart';

void main() {
  group('<inttypes.h>', () {
    test('imaxabs', () {
      expect(stdc.imaxabs(-9223372036854775807), equals(9223372036854775807));
      expect(stdc.imaxabs(42), equals(42));
    });

    test('imaxdiv', () {
      var res = stdc.imaxdiv(42, 5);
      expect(res.quot, equals(8));
      expect(res.rem, equals(2));
    });

    test('strtoimax', () {
      expect(stdc.strtoimax("12345"), equals(12345));
      expect(stdc.strtoimax("-12345"), equals(-12345));
      expect(stdc.strtoimax("1A", radix: 16), equals(26));
    });
  });
}

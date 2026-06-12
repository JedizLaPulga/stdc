import 'package:stdc/stdc.dart' hide group;
import 'package:test/test.dart';

void main() {
  group('stdlib', () {
    test('strtol, strtoul, strtoll, strtoull', () {
      List<String> endptr = [""];
      expect(stdc.strtol("  -12345 abc", endptr: endptr), -12345);
      expect(endptr[0], " abc");

      expect(stdc.strtol("0x1A", radix: 0), 26);
      expect(stdc.strtol("010", radix: 0), 8);
      
      expect(stdc.strtol("0x", endptr: endptr, radix: 0), 0);
      expect(endptr[0], "x");
      
      expect(stdc.strtol("xyz", endptr: endptr), 0);
      expect(endptr[0], "xyz");
    });

    test('strtod, strtof, strtold', () {
      List<String> endptr = [""];
      expect(stdc.strtod("  -123.45e2 abc", endptr: endptr), -12345.0);
      expect(endptr[0], " abc");

      expect(stdc.strtod("INFINITY"), double.infinity);
      expect(stdc.strtod("-INF"), double.negativeInfinity);
      expect(stdc.strtod("NaN").isNaN, true);
    });

    test('atoi, atol, atof', () {
      expect(stdc.atoi("123"), 123);
      expect(stdc.atoi("-42"), -42);
      expect(stdc.atoi("123abc"), 123); // Tests robust fallback

      expect(stdc.atol("2147483647"), 2147483647);
      
      expect(stdc.atof("3.14159"), 3.14159);
      expect(stdc.atof("3.14159abc"), 3.14159); // Tests robust fallback
    });

    test('labs, llabs', () {
      expect(stdc.labs(-100000), 100000);
      expect(stdc.llabs(-9999999999), 9999999999);
    });

    test('rand and srand', () {
      stdc.srand(42);
      int r1 = stdc.rand();
      stdc.srand(42);
      int r2 = stdc.rand();
      expect(r1, r2);
    });

    test('qsort', () {
      List<int> list = [5, 2, 9, 1, 5, 6];
      stdc.qsort(list, (a, b) => a.compareTo(b));
      expect(list, [1, 2, 5, 5, 6, 9]);
    });

    test('bsearch', () {
      List<int> sorted = [1, 2, 3, 4, 5, 6, 7, 8, 9];
      expect(stdc.bsearch(5, sorted, (a, b) => a.compareTo(b)), 5);
      expect(stdc.bsearch(10, sorted, (a, b) => a.compareTo(b)), null);
    });
  });
}

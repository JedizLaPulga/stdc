import 'package:stdc/stdc.dart';
import 'package:test/test.dart';

void main() {
  group('stdlib', () {
    test('atoi, atol, atof', () {
      expect(stdc.atoi("123"), 123);
      expect(stdc.atoi("-42"), -42);
      expect(stdc.atol("2147483647"), 2147483647);
      expect(stdc.atof("3.14159"), 3.14159);
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

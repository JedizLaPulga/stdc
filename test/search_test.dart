import 'package:stdc/stdc.dart' hide group;
import 'package:test/test.dart';

void main() {
  group('<search.h>', () {
    test('hsearch basic', () {
      stdc.hdestroy(); // ensure clean state
      expect(stdc.hcreate(10), equals(1));
      
      final entry1 = ENTRY("apple", "fruit");
      final entry2 = ENTRY("carrot", "vegetable");
      
      expect(stdc.hsearch(entry1, stdc.ENTER), equals(entry1));
      expect(stdc.hsearch(entry2, stdc.ENTER), equals(entry2));
      
      final found = stdc.hsearch(ENTRY("apple", null), stdc.FIND);
      expect(found, isNotNull);
      expect(found!.data, equals("fruit"));
      
      final notFound = stdc.hsearch(ENTRY("banana", null), stdc.FIND);
      expect(notFound, isNull);
      
      stdc.hdestroy();
    });

    test('lsearch and lfind', () {
      final list = [1, 2, 3];
      int compar(dynamic a, dynamic b) => (a as int).compareTo(b as int);
      
      expect(stdc.lfind(2, list, compar), equals(2));
      expect(stdc.lfind(4, list, compar), isNull);
      
      expect(stdc.lsearch(4, list, compar), equals(4));
      expect(list.length, equals(4));
      expect(list.last, equals(4));
    });

    test('tsearch and tfind', () {
      final rootp = <dynamic>[null];
      int compar(dynamic a, dynamic b) => (a as int).compareTo(b as int);
      
      expect(stdc.tsearch(5, rootp, compar), equals(5));
      expect(stdc.tsearch(3, rootp, compar), equals(3));
      expect(stdc.tsearch(7, rootp, compar), equals(7));
      
      expect(stdc.tfind(3, rootp, compar), equals(3));
      expect(stdc.tfind(10, rootp, compar), isNull);
      
      // tsearch of existing key should return the existing key
      expect(stdc.tsearch(3, rootp, compar), equals(3));
    });
  });
}

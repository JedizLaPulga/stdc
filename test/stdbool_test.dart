import 'package:test/test.dart';
import 'package:stdc/stdc.dart' hide group;

void main() {
  group('stdbool.h', () {
    test('Uppercase extensions', () {
      bool t = true;
      bool f = false;
      
      expect(t.ToInt(), 1);
      expect(f.ToInt(), 0);
      
      expect(t.Toggle(), false);
      expect(f.Toggle(), true);
    });

    test('stdc constants', () {
      expect(stdc.true_, true);
      expect(stdc.false_, false);
    });
  });
}

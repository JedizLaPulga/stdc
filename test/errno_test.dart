import 'package:test/test.dart';
import 'package:stdc/stdc.dart' hide group;

void main() {
  group('errno.h tests', () {
    setUp(() {
      stdc.errno = 0;
    });

    test('errno initial state', () {
      expect(stdc.errno, 0);
    });

    test('errno mutation', () {
      stdc.errno = stdc.EDOM;
      expect(stdc.errno, stdc.EDOM);
      expect(stdc.errno, 33);
    });

    test('errno standard constants exist', () {
      expect(stdc.ERANGE, 34);
      expect(stdc.EINVAL, 22);
    });
  });
}

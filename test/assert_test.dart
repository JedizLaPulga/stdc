import 'package:test/test.dart';
import 'package:stdc/stdc.dart';

void main() {
  group('assert.h tests', () {
    test('assert passes on true', () {
      expect(() => stdc.assert_(true), returnsNormally);
      expect(() => stdc.cassert(true), returnsNormally);
    });

    test('assert fails on false', () {
      expect(() => stdc.assert_(false), throwsA(isA<AssertionError>()));
      expect(() => stdc.cassert(false), throwsA(isA<AssertionError>()));
    });
    
    test('assert fails with custom message', () {
      try {
        stdc.assert_(false, "Custom error message");
      } catch (e) {
        expect(e, isA<AssertionError>());
        expect(e.toString(), contains("Custom error message"));
      }
    });
  });
}

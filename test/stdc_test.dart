import 'package:stdc/math.dart';
import 'package:test/test.dart';

void main() {
  group('math.h', () {
    test('sqrt', () {
      expect(stdc.sqrt(16.0), equals(4.0));
      expect(stdc.sqrt(2.0), closeTo(1.414, 0.001));
    });

    test('pow', () {
      expect(stdc.pow(2.0, 3.0), equals(8.0));
      expect(stdc.pow(5.0, 2.0), equals(25.0));
    });

    test('sin, cos, tan', () {
      // 0 radians
      expect(stdc.sin(0.0), equals(0.0));
      expect(stdc.cos(0.0), equals(1.0));
      expect(stdc.tan(0.0), equals(0.0));
    });

    test('fabs and abs', () {
      expect(stdc.fabs(-5.5), equals(5.5));
      expect(stdc.fabs(3.14), equals(3.14));
      
      expect(stdc.abs(-10), equals(10));
      expect(stdc.abs(42), equals(42));
    });

    test('ceil and floor', () {
      expect(stdc.ceil(3.14), equals(4.0));
      expect(stdc.floor(3.14), equals(3.0));
      
      expect(stdc.ceil(-3.14), equals(-3.0));
      expect(stdc.floor(-3.14), equals(-4.0));
    });
  });
}

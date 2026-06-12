import 'package:test/test.dart';
import 'package:stdc/stdc.dart' hide group;

void main() {
  group('<complex.h>', () {
    test('cabs', () {
      var z = complex(3.0, 4.0);
      expect(stdc.cabs(z), equals(5.0));
    });

    test('cexp', () {
      var z = complex(0.0, 3.141592653589793); // e^(i*pi) = -1
      var res = stdc.cexp(z);
      expect(res.real, closeTo(-1.0, 1e-10));
      expect(res.imag, closeTo(0.0, 1e-10));
    });

    test('csqrt', () {
      var z = complex(-1.0, 0.0);
      var res = stdc.csqrt(z);
      expect(res.real, closeTo(0.0, 1e-10));
      expect(res.imag, closeTo(1.0, 1e-10));
    });
  });
}

// ignore_for_file: camel_case_types
// Complex number arithmetic (`<complex.h>`).

import 'dart:math' as math;
import 'src/stdc_base.dart';

/// Represents a complex number `real + imag * i`.
class complex {
  /// The real part of the complex number.
  final double real;
  
  /// The imaginary part of the complex number.
  final double imag;
  
  /// Creates a complex number with the given [real] and [imag] parts.
  const complex(this.real, this.imag);

  @override
  String toString() => '$real + ${imag}i';
  
  @override
  bool operator ==(Object other) => other is complex && real == other.real && imag == other.imag;

  @override
  int get hashCode => Object.hash(real, imag);
}

/// Alias for [complex] mapping to C's `float complex`.
typedef float_complex = complex;

/// Alias for [complex] mapping to C's `double complex`.
typedef double_complex = complex;

/// Standard complex math operations.
extension ComplexStdc on Stdc {
  /// Computes the complex absolute value (magnitude) of [z].
  double cabs(complex z) => math.sqrt(z.real * z.real + z.imag * z.imag);
  
  /// Computes the complex base-e exponential of [z].
  complex cexp(complex z) {
    double expReal = math.exp(z.real);
    return complex(expReal * math.cos(z.imag), expReal * math.sin(z.imag));
  }
  
  /// Computes the complex square root of [z].
  complex csqrt(complex z) {
    double r = cabs(z);
    double sign = z.imag < 0 ? -1.0 : 1.0;
    return complex(
      math.sqrt((r + z.real) / 2.0),
      sign * math.sqrt((r - z.real) / 2.0)
    );
  }

  double _cosh(double x) => (math.exp(x) + math.exp(-x)) / 2.0;
  double _sinh(double x) => (math.exp(x) - math.exp(-x)) / 2.0;
  
  /// Computes the complex cosine of [z].
  complex ccos(complex z) => complex(
    math.cos(z.real) * _cosh(z.imag),
    -math.sin(z.real) * _sinh(z.imag)
  );
  
  /// Computes the complex sine of [z].
  complex csin(complex z) => complex(
    math.sin(z.real) * _cosh(z.imag),
    math.cos(z.real) * _sinh(z.imag)
  );

  /// Computes the complex tangent of [z].
  complex ctan(complex z) {
    double d = math.cos(2 * z.real) + _cosh(2 * z.imag);
    return complex(math.sin(2 * z.real) / d, _sinh(2 * z.imag) / d);
  }
}

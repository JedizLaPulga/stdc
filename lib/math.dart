/// `<math.h>` implementation for stdc
/// 
/// Contains standard mathematical functions for the `stdc` library.
library;

export 'src/stdc_base.dart';
import 'src/stdc_base.dart';
import 'dart:math' as dart_math;

/// Extension on [Stdc] to provide `<math.h>` functionality.
/// 
/// Importing this file attaches standard C mathematical functions
/// directly to the global `stdc` instance.
extension MathStdc on Stdc {
  
  /// Computes the cosine of [x] (measured in radians).
  double cos(double x) => dart_math.cos(x);

  /// Computes the sine of [x] (measured in radians).
  double sin(double x) => dart_math.sin(x);

  /// Computes the tangent of [x] (measured in radians).
  double tan(double x) => dart_math.tan(x);

  /// Computes the principal value of the arc cosine of [x].
  double acos(double x) => dart_math.acos(x);

  /// Computes the principal value of the arc sine of [x].
  double asin(double x) => dart_math.asin(x);

  /// Computes the principal value of the arc tangent of [x].
  double atan(double x) => dart_math.atan(x);

  /// Computes the arc tangent of [y]/[x] using the signs of arguments to determine the correct quadrant.
  double atan2(double y, double x) => dart_math.atan2(y, x);

  /// Computes the base-e exponential of [x].
  double exp(double x) => dart_math.exp(x);

  /// Computes the natural (base-e) logarithm of [x].
  double log(double x) => dart_math.log(x);

  /// Computes the base-10 logarithm of [x].
  double log10(double x) => dart_math.log(x) / dart_math.ln10;

  /// Computes [base] raised to the power [exponent].
  double pow(double base, double exponent) => dart_math.pow(base, exponent).toDouble();

  /// Computes the non-negative square root of [x].
  double sqrt(double x) => dart_math.sqrt(x);

  /// Computes the smallest integer value not less than [x].
  double ceil(double x) => x.ceilToDouble();

  /// Computes the largest integer value not greater than [x].
  double floor(double x) => x.floorToDouble();

  /// Computes the absolute value of a floating-point number [x].
  double fabs(double x) => x.abs();

  /// Computes the absolute value of an integer [x].
  int abs(int x) => x.abs();

  /// Computes the floating-point remainder of [x]/[y].
  double fmod(double x, double y) => x.remainder(y);

  /// Returns the larger of its arguments.
  double fmax(double x, double y) => dart_math.max(x, y);

  /// Returns the smaller of its arguments.
  double fmin(double x, double y) => dart_math.min(x, y);

  /// Computes the square root of the sum of the squares of [x] and [y] without undue overflow or underflow.
  double hypot(double x, double y) {
    if (x == 0) return y.abs();
    if (y == 0) return x.abs();
    final double maxAbs = dart_math.max(x.abs(), y.abs());
    final double minAbs = dart_math.min(x.abs(), y.abs());
    final double ratio = minAbs / maxAbs;
    return maxAbs * dart_math.sqrt(1.0 + ratio * ratio);
  }

  /// Rounds [x] to the nearest integer value, rounding halfway cases away from zero.
  double round(double x) => x.roundToDouble();

  /// Rounds [x] toward zero to the nearest integer value.
  double trunc(double x) => x.truncateToDouble();

  /// Computes the cube root of [x].
  double cbrt(double x) {
    if (x < 0) {
      return -dart_math.pow(-x, 1.0 / 3.0).toDouble();
    }
    return dart_math.pow(x, 1.0 / 3.0).toDouble();
  }
}

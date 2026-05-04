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
}

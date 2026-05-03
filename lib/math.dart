// `<math.h>` implementation for stdc
// 
// Contains standard mathematical functions for the `stdc` library.

export 'src/stdc_base.dart';
import 'src/stdc_base.dart';
import 'dart:math' as dart_math;

extension MathStdc on Stdc {
  // Trigonometric functions
  double cos(double x) => dart_math.cos(x);
  double sin(double x) => dart_math.sin(x);
  double tan(double x) => dart_math.tan(x);
  double acos(double x) => dart_math.acos(x);
  double asin(double x) => dart_math.asin(x);
  double atan(double x) => dart_math.atan(x);
  double atan2(double y, double x) => dart_math.atan2(y, x);

  // Hyperbolic functions (Wait, dart:math doesn't have sinh, cosh directly, but let's stick to what's available or implement via exp)
  // For simplicity we will stick to native dart:math functions initially.

  // Exponential and logarithmic functions
  double exp(double x) => dart_math.exp(x);
  double log(double x) => dart_math.log(x); // Natural logarithm
  double log10(double x) => dart_math.log(x) / dart_math.ln10;

  // Power functions
  double pow(double base, double exponent) => dart_math.pow(base, exponent).toDouble();
  double sqrt(double x) => dart_math.sqrt(x);

  // Nearest integer, absolute value, and remainder functions
  double ceil(double x) => x.ceilToDouble();
  double floor(double x) => x.floorToDouble();
  double fabs(double x) => x.abs(); // `fabs` in C is float absolute value
  int abs(int x) => x.abs(); // `abs` in C is integer absolute value
}

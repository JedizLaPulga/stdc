// ignore_for_file: camel_case_types, non_constant_identifier_names
/// `<float.h>` implementation for stdc
/// 
/// Contains core floating-point characteristics.
library;

import 'src/stdc_base.dart';

/// Extension on [Stdc] to provide `<float.h>` functionality.
/// 
/// Note: Dart only uses IEEE 754 double-precision 64-bit floating-point numbers.
/// To emulate standard C characteristics, `FLT_` constants represent common
/// 32-bit float boundaries, while `DBL_` constants represent 64-bit bounds.
extension StdcFloat on Stdc {
  // --- Radix ---
  
  /// Radix of exponent representation.
  int get FLT_RADIX => 2;

  // --- Float Characteristics (32-bit equivalent) ---
  
  /// Number of decimal digits of precision for a float.
  int get FLT_DIG => 6;
  
  /// Difference between 1 and the least value greater than 1 that is representable.
  double get FLT_EPSILON => 1.19209290e-07;
  
  /// Minimum normalized positive floating-point number.
  double get FLT_MIN => 1.17549435e-38;
  
  /// Maximum representable finite floating-point number.
  double get FLT_MAX => 3.40282347e+38;

  // --- Double Characteristics (64-bit equivalent) ---
  
  /// Number of decimal digits of precision for a double.
  int get DBL_DIG => 15;
  
  /// Difference between 1 and the least value greater than 1 that is representable.
  double get DBL_EPSILON => 2.2204460492503131e-16;
  
  /// Minimum normalized positive double-precision number.
  double get DBL_MIN => 2.2250738585072014e-308;
  
  /// Maximum representable finite double-precision number.
  double get DBL_MAX => 1.7976931348623157e+308;
}

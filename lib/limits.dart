// ignore_for_file: camel_case_types, non_constant_identifier_names
/// `<limits.h>` implementation for stdc
/// 
/// Contains core integer limit boundaries.
library;

import 'src/stdc_base.dart';

/// Extension on [Stdc] to provide `<limits.h>` functionality.
/// 
/// Note: Dart only uses 64-bit integers (`int`).
/// To emulate standard C characteristics, standard 32-bit bounds 
/// are mapped for `INT_` and `LONG_` is mapped to 64-bit.
extension StdcLimits on Stdc {
  /// Number of bits in a char
  int get CHAR_BIT => 8;

  /// Minimum value for a signed char
  int get SCHAR_MIN => -128;

  /// Maximum value for a signed char
  int get SCHAR_MAX => 127;

  /// Maximum value for an unsigned char
  int get UCHAR_MAX => 255;

  /// Minimum value for a char
  int get CHAR_MIN => -128;

  /// Maximum value for a char
  int get CHAR_MAX => 127;

  /// Minimum value for a short int
  int get SHRT_MIN => -32768;

  /// Maximum value for a short int
  int get SHRT_MAX => 32767;

  /// Maximum value for an unsigned short int
  int get USHRT_MAX => 65535;

  /// Minimum value for an int (Assuming 32-bit mapping)
  int get INT_MIN => -2147483648;

  /// Maximum value for an int (Assuming 32-bit mapping)
  int get INT_MAX => 2147483647;

  /// Maximum value for an unsigned int (Assuming 32-bit mapping)
  int get UINT_MAX => 4294967295;

  /// Minimum value for a long int (Assuming 64-bit mapping)
  int get LONG_MIN => -9223372036854775808;

  /// Maximum value for a long int (Assuming 64-bit mapping)
  int get LONG_MAX => 9223372036854775807;

  /// Maximum value for an unsigned long int (Mapping to Dart's max safe integer since Dart doesn't have unsigned 64-bit)
  /// Using maximum 64-bit signed as approximation. 
  /// NOTE: A true unsigned 64-bit int max is 18446744073709551615, but Dart's 
  /// `int` cannot hold it safely without third-party types.
  int get ULONG_MAX => 9223372036854775807; // Fails to represent true 64-bit unsigned max natively

  /// Minimum value for a long long int
  int get LLONG_MIN => -9223372036854775808;

  /// Maximum value for a long long int
  int get LLONG_MAX => 9223372036854775807;

  /// Maximum value for an unsigned long long int
  int get ULLONG_MAX => 9223372036854775807; // Fails to represent true 64-bit unsigned max natively
}

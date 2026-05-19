// ignore_for_file: camel_case_types, non_constant_identifier_names
/// `<stdint.h>` implementation for stdc
///
/// Contains standard exact-width integer types.
library;

import 'src/stdc_base.dart';

// Fast, zero-overhead typedefs mapping to Dart's int
/// 8-bit signed integer type.
typedef int8_t = int;
/// 8-bit unsigned integer type.
typedef uint8_t = int;
/// 16-bit signed integer type.
typedef int16_t = int;
/// 16-bit unsigned integer type.
typedef uint16_t = int;
/// 32-bit signed integer type.
typedef int32_t = int;
/// 32-bit unsigned integer type.
typedef uint32_t = int;
/// 64-bit signed integer type.
typedef int64_t = int;
/// 64-bit unsigned integer type.
typedef uint64_t = int;
/// Maximum-width signed integer type.
typedef intmax_t = int;
/// Maximum-width unsigned integer type.
typedef uintmax_t = int;
/// Integer type capable of holding a pointer.
typedef intptr_t = int;
/// Unsigned integer type capable of holding a pointer.
typedef uintptr_t = int;

// Strict Dart 3.3 extension types for compile-time checking with zero runtime overhead
/// Strict 8-bit signed integer extension type.
extension type const Int8._(
  /// The underlying integer value.
  int value
) implements int {
  /// Creates a strict 8-bit signed integer.
  const Int8(int value) : this._(value);
}
/// Strict 8-bit unsigned integer extension type.
extension type const Uint8._(
  /// The underlying integer value.
  int value
) implements int {
  /// Creates a strict 8-bit unsigned integer.
  const Uint8(int value) : this._(value);
}
/// Strict 16-bit signed integer extension type.
extension type const Int16._(
  /// The underlying integer value.
  int value
) implements int {
  /// Creates a strict 16-bit signed integer.
  const Int16(int value) : this._(value);
}
/// Strict 16-bit unsigned integer extension type.
extension type const Uint16._(
  /// The underlying integer value.
  int value
) implements int {
  /// Creates a strict 16-bit unsigned integer.
  const Uint16(int value) : this._(value);
}
/// Strict 32-bit signed integer extension type.
extension type const Int32._(
  /// The underlying integer value.
  int value
) implements int {
  /// Creates a strict 32-bit signed integer.
  const Int32(int value) : this._(value);
}
/// Strict 32-bit unsigned integer extension type.
extension type const Uint32._(
  /// The underlying integer value.
  int value
) implements int {
  /// Creates a strict 32-bit unsigned integer.
  const Uint32(int value) : this._(value);
}
/// Strict 64-bit signed integer extension type.
extension type const Int64._(
  /// The underlying integer value.
  int value
) implements int {
  /// Creates a strict 64-bit signed integer.
  const Int64(int value) : this._(value);
}
/// Strict 64-bit unsigned integer extension type.
extension type const Uint64._(
  /// The underlying integer value.
  int value
) implements int {
  /// Creates a strict 64-bit unsigned integer.
  const Uint64(int value) : this._(value);
}

/// Extension to provide related constants under the `stdc` namespace.
extension StdintStdc on Stdc {
  /// Maximum value of an 8-bit signed integer.
  int get INT8_MAX => 127;
  /// Minimum value of an 8-bit signed integer.
  int get INT8_MIN => -128;
  /// Maximum value of an 8-bit unsigned integer.
  int get UINT8_MAX => 255;

  /// Maximum value of a 16-bit signed integer.
  int get INT16_MAX => 32767;
  /// Minimum value of a 16-bit signed integer.
  int get INT16_MIN => -32768;
  /// Maximum value of a 16-bit unsigned integer.
  int get UINT16_MAX => 65535;

  /// Maximum value of a 32-bit signed integer.
  int get INT32_MAX => 2147483647;
  /// Minimum value of a 32-bit signed integer.
  int get INT32_MIN => -2147483648;
  /// Maximum value of a 32-bit unsigned integer.
  int get UINT32_MAX => 4294967295;

  /// Maximum value of a 64-bit signed integer.
  int get INT64_MAX => 9223372036854775807;
  /// Minimum value of a 64-bit signed integer.
  int get INT64_MIN => -9223372036854775808;
  
  // Note: `UINT64_MAX` (18446744073709551615) is intentionally omitted. 
  // Dart's `int` is a signed 64-bit integer, and this value would exceed
  // the maximum representable bounds, leading to overflow or requiring `BigInt`.
}

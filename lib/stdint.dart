// ignore_for_file: camel_case_types, non_constant_identifier_names
// Standard exact-width integer types (`<stdint.h>`).

import 'src/stdc_base.dart';

// Fast, zero-overhead typedefs mapping to Dart's int
typedef int8_t = int;
typedef uint8_t = int;
typedef int16_t = int;
typedef uint16_t = int;
typedef int32_t = int;
typedef uint32_t = int;
typedef int64_t = int;
typedef uint64_t = int;
typedef intmax_t = int;
typedef uintmax_t = int;
typedef intptr_t = int;
typedef uintptr_t = int;

// Strict Dart 3.3 extension types for compile-time checking with zero runtime overhead
extension type Int8(int value) implements int {}
extension type Uint8(int value) implements int {}
extension type Int16(int value) implements int {}
extension type Uint16(int value) implements int {}
extension type Int32(int value) implements int {}
extension type Uint32(int value) implements int {}
extension type Int64(int value) implements int {}
extension type Uint64(int value) implements int {}

/// Extension to provide related constants under the `stdc` namespace.
extension StdintStdc on Stdc {
  int get INT8_MAX => 127;
  int get INT8_MIN => -128;
  int get UINT8_MAX => 255;

  int get INT16_MAX => 32767;
  int get INT16_MIN => -32768;
  int get UINT16_MAX => 65535;

  int get INT32_MAX => 2147483647;
  int get INT32_MIN => -2147483648;
  int get UINT32_MAX => 4294967295;

  int get INT64_MAX => 9223372036854775807;
  int get INT64_MIN => -9223372036854775808;
  
  // Note: `UINT64_MAX` (18446744073709551615) is intentionally omitted. 
  // Dart's `int` is a signed 64-bit integer, and this value would exceed
  // the maximum representable bounds, leading to overflow or requiring `BigInt`.
}

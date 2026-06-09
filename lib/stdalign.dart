// ignore_for_file: camel_case_types

/// `<stdalign.h>` implementation for stdc
/// 
/// Dart does not allow manual memory alignment control like C (`alignas`, `alignof`).
/// This file is provided for standard library completeness.
library;

/// A stub class to represent an alignment annotation structurally.
class alignas {
  /// The alignment boundary in bytes.
  final int alignment;
  /// Creates an alignment annotation.
  const alignas(this.alignment);
}

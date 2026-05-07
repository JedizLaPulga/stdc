// ignore_for_file: camel_case_types, non_constant_identifier_names
// Standard type definitions (`<stddef.h>`).

import 'src/stdc_base.dart';

/// Unsigned integral type of the result of the sizeof operator.
typedef size_t = int;

/// Signed integral type of the result of subtracting two pointers.
typedef ptrdiff_t = int;

/// Provides standard `stddef` definitions under the `stdc` namespace.
extension StddefStdc on Stdc {
  /// Null pointer constant. Maps directly to Dart's `null`.
  dynamic get NULL => null;
}

// ignore_for_file: camel_case_types, non_constant_identifier_names
/// `<stdbool.h>` implementation for stdc
///
/// Contains standard boolean types and utilities.
library;

import 'src/stdc_base.dart';

/// Defines `stdbool` as a typedef to Dart's `bool`.
typedef stdbool = bool;

/// Provides quality-of-life computations on booleans.
/// Note: All non-standard derived utility methods begin with an **Uppercase** letter
/// to cleanly distinguish them from standard APIs.
extension StdboolExtensions on bool {
  /// Toggles the boolean value and returns the new value.
  bool Toggle() => !this;

  /// Converts the boolean to an integer (1 for true, 0 for false), matching C behavior.
  int ToInt() => this ? 1 : 0;
}

/// Provides boolean constants under the `stdc` namespace.
extension StdboolStdc on Stdc {
  /// Standard true representation.
  bool get true_ => true;

  /// Standard false representation.
  bool get false_ => false;
}

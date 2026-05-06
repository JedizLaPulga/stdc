/// `<assert.h>` implementation for stdc
/// 
/// Contains standard C-style runtime assertions.
library;

import 'src/stdc_base.dart';

/// Extension on [Stdc] to provide `<assert.h>` functionality.
extension StdcAssert on Stdc {
  /// Asserts that [expression] is true. 
  /// 
  /// If the expression is false, an [AssertionError] is thrown with the 
  /// optional [message]. 
  /// 
  /// Note: In C, this is the `assert` macro. Because `assert` is a reserved 
  /// keyword in Dart, we use `assert_` or `cassert` for implementation, 
  /// while still mapping logically to `<assert.h>`.
  void assert_(bool expression, [String? message]) {
    if (!expression) {
      if (message != null) {
        throw AssertionError(message);
      } else {
        throw AssertionError();
      }
    }
  }

  /// Alias for [assert_] for developers who prefer a prefix instead of an underscore.
  void cassert(bool expression, [String? message]) {
    assert_(expression, message);
  }
}

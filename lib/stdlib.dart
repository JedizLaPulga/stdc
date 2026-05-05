/// `<stdlib.h>` implementation for stdc
/// 
/// Contains standard utility functions for the `stdc` library.
library;

import 'dart:math' as math;
import 'src/stdc_base.dart';

// Internal state for random number generation
math.Random _rand = math.Random();

/// `<stdlib.h>` standard library extensions for `stdc`.
extension StdcStdlib on Stdc {
  // --- String Conversions ---

  /// Converts a string to an integer.
  int atoi(String str) {
    return int.tryParse(str) ?? 0;
  }

  /// Converts a string to a long integer.
  int atol(String str) {
    return int.tryParse(str) ?? 0;
  }

  /// Converts a string to a double.
  double atof(String str) {
    return double.tryParse(str) ?? 0.0;
  }

  // --- Pseudo-Random Sequence Generation ---

  /// Seeds the pseudo-random number generator used by [rand].
  void srand(int seed) {
    _rand = math.Random(seed);
  }

  /// Returns a pseudo-random integer between 0 and 0x7FFFFFFF.
  int rand() {
    return _rand.nextInt(0x7FFFFFFF);
  }

  // --- Integer Arithmetic ---

  /// Computes the absolute value of a long integer.
  int labs(int n) => n.abs();

  /// Computes the absolute value of a long long integer.
  int llabs(int n) => n.abs();

  // --- Searching and Sorting ---

  /// Sorts an array (list) using a comparator function.
  /// Modifies the list in-place.
  void qsort<T>(List<T> base, int Function(T a, T b) compar) {
    base.sort(compar);
  }

  /// Performs a binary search on a sorted array (list).
  /// Returns the matching element, or null if not found.
  T? bsearch<T>(T key, List<T> base, int Function(T a, T b) compar) {
    int min = 0;
    int max = base.length - 1;
    while (min <= max) {
      int mid = min + ((max - min) >> 1);
      int cmp = compar(key, base[mid]);
      if (cmp == 0) return base[mid];
      if (cmp < 0) {
        max = mid - 1;
      } else {
        min = mid + 1;
      }
    }
    return null;
  }
}

## 1.0.4

- **Massive Systems-Level Feature Expansion:** Added support for three core C standard headers simultaneously (`<stdlib.h>`, `<stdio.h>`, `<time.h>`), significantly expanding the library's utility for C programmers seeking a zero-abstraction environment in Dart.
- **`<stdlib.h>` Addition**: Implemented essential standard library utilities mapping directly to native-equivalent concepts:
  - String conversions: `atoi`, `atol`, `atof`.
  - Pseudo-random number generation: `rand`, `srand`.
  - Integer arithmetic: `abs`, `labs`, `llabs`.
  - Searching and sorting: `qsort`, `bsearch` (designed to use pure Dart's optimized algorithms while exposing the familiar C signatures with comparators).
- **`<stdio.h>` Addition**: Brought raw, authentic C-style I/O to Dart using direct `dart:io` hooks where appropriate:
  - Formatted I/O: Added a lightweight, zero-dependency `sprintf` and `printf` implementation that mimics C's format specifiers (`%d`, `%s`, `%f`, `%x`, etc.) without bloating the library.
  - Character and String Output: `puts`, `putchar`.
  - Standard Input: `getchar`, `gets`.
- **`<time.h>` Addition**: Implemented low-level time tracking utilities mapping to system ticks and epochs:
  - Core timing: `time`, `clock`.
  - Utility functions: `difftime`, `ctime`.

## 1.0.3
- **`<string.h>` Addition**: Implemented standard C string manipulation functions (`strlen`, `strcmp`, `strcpy`, `strcat`, `strstr`, etc.). Mutating functions like `strcpy` and `strcat` have been adapted to return a new string, adhering to Dart's immutable `String` nature while maintaining familiar C naming conventions.

## 1.0.2

- **`<ctype.h>` Addition**: Implemented standard character classification and conversion functions (`isalpha`, `isdigit`, `toupper`, `tolower`, etc.). Designed to accept `String` inputs for ergonomic use in Dart while maintaining native performance.

## 1.0.1

- **Version Reset**: Reset versioning to `0.1.0` to properly track early development of the library before a stable `1.0.0` release.
- **Initial Architecture Setup**: Implemented the core `Stdc` extension architecture, allowing a unified `stdc` namespace across different headers.
- **`<math.h>` Implemented**: Added comprehensive support for C standard math functions (`sin`, `cos`, `sqrt`, `pow`, `ceil`, `floor`, `abs`, `fabs`, etc.) mapped to Dart's highly optimized `dart:math`.
- **Examples & Tests**: Created `example/stdc_example.dart` and `test/stdc_test.dart`.
- **Documentation**: Added comprehensive API dartdoc comments to all functions, classes, and constants.

## 1.0.0

- Initial placeholder version from Dart template creation.

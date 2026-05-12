## v1.1.0 - May 12th 2026

- **Variadic Arguments Support**: Implemented `<stdarg.h>` features, allowing developers to write and use C-style variadic functions in Dart.
- **`va_list` and Macros**: Added the `va_list` wrapper class along with `va_start`, `va_arg`, `va_end`, and `va_copy` extensions to safely manage variable argument lists.
- **`<stdio.h>` Enhancement**: Introduced `vprintf` and `vsprintf`, completing the formatted I/O suite by enabling format strings to be processed with an initialized `va_list`. Refactored `printf` and `sprintf` to rely on these robust underlying implementations.

## v1.0.9 - May 10th 2026

- **Debugging & Improvements**: Focused strictly on bug fixes and C-standard compliance for existing functionality without introducing new headers.
- **`<inttypes.h>` Enhancements**: Replaced the underlying string parser in `strtoimax` and `strtoumax`. The new implementation strictly mirrors C behavior: it skips leading whitespace, handles optional signs, auto-detects numerical bases (when `radix: 0`), and gracefully stops at the first invalid character instead of throwing exceptions.
- **`<stdint.h>` Documentation**: Added developer notes clarifying the mapping limits of `UINT64_MAX` within Dart's signed 64-bit integer environment.

## v1.0.8 - May 9th 2026

- **Wide Character and Localization Support**: Completed text handling capabilities by implementing C95/C99 wide character features and system localization stubs (`<locale.h>`, `<wchar.h>`, `<wctype.h>`).
- **`<locale.h>` Addition**: Provided the `Lconv` class (mapping to `struct lconv`) populated with standard "C" locale defaults. Added `setlocale` and `localeconv` functions, along with localization category macros (`LC_ALL`, `LC_CTYPE`, etc.).
- **`<wchar.h>` Addition**: Introduced `wchar_t` and `wint_t` definitions mapping to Dart `int` (Runes), adhering to a strict C-like memory representation for wide strings (`List<wchar_t>`). Implemented wide string manipulation functions (`wcslen`, `wcscpy`, `wcscmp`, `wcscat`, `wcschr`, `wcsstr`).
- **`<wctype.h>` Addition**: Added wide character classification and mapping functions (`iswalpha`, `iswdigit`, `towlower`, `towupper`, etc.) natively supporting standard integer-based code unit evaluation.
- **Documentation & Linting Polish**: Added missing API documentation comments across public symbols (including `complex` and `inttypes` extensions) to ensure comprehensive documentation coverage. Intentionally silenced `camel_case_types` warnings for C-style type definitions (like `wchar_t` and `wint_t`) to maintain authentic C naming conventions while preserving pub.dev score.

## v1.0.7 - May 8th 2026

- **Complex Mathematics, Extended Integers, and Unicode Support**: Expanded the library's domain to cover C99 and C11 specialized headers (`<complex.h>`, `<inttypes.h>`, `<uchar.h>`).
- **`<complex.h>` Addition**: Provided `complex`, `double complex`, and `float complex` type definitions. Implemented core complex arithmetic and transcendental functions (`cabs`, `cacos`, `casin`, `catan`, `ccos`, `csin`, `ctan`, `cexp`, `clog`, `cpow`, `csqrt`) via a zero-overhead architecture.
- **`<inttypes.h>` Addition**: Introduced extended integer utilities, directly building upon `<stdint.h>`. Added `imaxabs`, `imaxdiv`, `strtoimax`, and `strtoumax` functions for working with maximum-width integer types seamlessly.
- **`<uchar.h>` Addition**: Provided C11 Unicode type definitions (`char16_t`, `char32_t`) and implemented standard conversion functions (`mbrtoc16`, `c16rtomb`, `mbrtoc32`, `c32rtomb`), mapping directly to Dart's highly optimized UTF-16 strings and runes.

## v1.0.6 - May 7th 2026

- **Standard Type Definitions & Constraints Expansion**: Added standard C integer bounds, boolean utilities, and pointer type definitions (`<stdint.h>`, `<stdbool.h>`, `<stddef.h>`).
- **`<stdint.h>` Addition**: Provided `extension type` strict definitions for native C-like integers (`Int8`, `Uint32`, etc.) matching standard C widths without sacrificing zero-overhead performance. Also provided fast `typedef` alias options (`int8_t`, `uint32_t`).
- **`<stdbool.h>` Addition**: Implemented `<stdbool.h>` equivalents. Introduced quality-of-life `bool` extension utilities (e.g., `Toggle()`, `ToInt()`). Note: All non-standard derived utility methods begin with an **Uppercase** letter to cleanly distinguish them from standard APIs.
- **`<stddef.h>` Addition**: Provided `size_t` and `ptrdiff_t` aliases, alongside `stdc.NULL` mapping to Dart's `null`.
- **Web/Wasm Compatibility**: Refactored `<stdio.h>` to decouple it from `dart:io`. Implemented conditional imports (`src/io_stub.dart` and `src/io_native.dart`) to ensure the entire `stdc` package compiles and runs flawlessly on Web and Wasm targets, automatically falling back to `print()` for console output on the web.

## v1.0.5 - May 6th 2026

- **Essential Systems Boundaries & Diagnostics**: Expanded `stdc` with core limit definitions, floating-point characteristics, and system diagnostics headers.
- **`<limits.h>` Addition**: Provided constants for standard C integer limits (`INT_MAX`, `UINT_MAX`, `CHAR_BIT`, etc.), mapped to traditional C 32-bit bounds for `int` and 64-bit for `long long`.
- **`<float.h>` Addition**: Provided standard C floating-point characteristics (`FLT_MAX`, `DBL_MAX`, `FLT_EPSILON`, etc.).
- **`<assert.h>` Addition**: Implemented runtime assertions. Due to `assert` being a reserved keyword in Dart, the function is implemented as `stdc.assert_()` or `stdc.cassert()`, but documented as the C-equivalent `assert`.
- **`<errno.h>` Addition**: Added global error state tracking (`stdc.errno`) and standard error macros (`EDOM`, `ERANGE`, etc.) to support C-style error reporting.

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

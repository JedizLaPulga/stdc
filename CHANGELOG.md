## v1.1.6 - May 24th 2026

- **Mutable Strings (`<string.h>`)**: Introduced `CString` class backed by `Uint8List` to emulate C char buffers, allowing true in-place buffer mutation.
- **Memory Functions (`<string.h>`)**: Added `memset`, `memcpy`, `memcmp`, `strcpyBuffer`, `strncpyBuffer`, `strcatBuffer`, `strncatBuffer`, `strlenBuffer`, and `strcmpBuffer`.
- **Code Quality**: Fixed flow-control lint warnings in `stdio.dart` to prevent potential "goto fail" style bugs.
- **Documentation**: Added missing public API documentation comments for native and stub I/O interfaces.

## v1.1.5 - May 21st 2026

- **Full `printf`/`sprintf` Format Specifier Support (`<stdio.h>`)**: Completely overhauled the `vsprintf` engine to match C99 formatting rules, making `printf` and `sprintf` truly production-ready.
  - **Flags**: `-` (left-align), `+` (force sign), ` ` (space sign), `0` (zero-pad), `#` (alternate form: `0x`/`0X` for hex, `0` for octal, always decimal point for `%#f`).
  - **Width**: Integer literal (`%10d`) or dynamic from argument (`%*d`).
  - **Precision**: `.n` literal (`%.4f`) or dynamic from argument (`%.*f`). For `%s`, precision limits the maximum character count. For integers, precision sets the minimum digit count.
  - **New specifiers**: `%u` (unsigned decimal), `%o` (octal), `%e`/`%E` (scientific notation with C-standard 2-digit exponent), `%g`/`%G` (shorter of `%f`/`%e`, trailing zeros stripped), `%p` (pointer address via `identityHashCode`).
  - **Length modifiers**: `h`, `l`, `ll`, `L`, `z`, `t`, `j` are consumed and safely ignored (Dart integers are always 64-bit).
  - **Special float values**: `nan` and `inf` are rendered correctly across all float specifiers.
- **`snprintf` Addition (`<stdio.h>`)**: Added `snprintf(int n, String format, [...])` — the size-limited safe variant of `sprintf`. Truncates the output to at most `n-1` characters, mirroring C's null-terminator convention. Returns the truncated `String`. Deviation from C: returns a `String` directly rather than writing to a buffer.
- **`sscanf` and `scanf` Addition (`<stdio.h>`)**: Implemented the input-parsing counterpart to `printf`.
  - `sscanf(String str, String format)` parses a string according to a C-style format, returning a `List<dynamic>` of matched values. The list length equals C's integer return value (number of successfully matched items).
  - `scanf(String format)` reads one line from `stdin` and delegates to `sscanf`.
  - Supports specifiers: `%d`, `%i` (auto-base: `0x` hex, `0` octal), `%u`, `%o`, `%x`/`%X`, `%f`/`%e`/`%g` (all map to `double`), `%s` (whitespace-delimited token), `%c` (single character), `%n` (chars consumed so far), `%%` (literal match).
  - Supports **width** (`%5d` reads at most 5 chars) and **suppress-assignment** (`%*d` discards a matched value without adding it to the result list).
  - Deviation from C: uses returned `List<dynamic>` instead of out-pointer arguments.

## v1.1.4 - May 19th 2026

- **Documentation Enhancements**: Achieved 100% API documentation coverage to improve `pana` scores and provide better developer experience. Added missing doc comments to `Lconv` properties, `Lconv` constructor, `complex` library, and `inttypes` library.

## v1.1.3 - May 17th 2026

- **Signal Handling (`<signal.h>`)**: Introduced native-feeling signal interception and generation for Dart environments.
  - Implemented `signal()` for subscribing to standard process events (`SIGINT`, `SIGTERM`, etc.) using an underlying `dart:io` `ProcessSignal` architecture.
  - Provided `raise()` to manually trigger custom handler behaviors or default system responses.
  - Included standard POSIX signal constants (`SIGABRT`, `SIGFPE`, `SIGILL`, `SIGINT`, `SIGSEGV`, `SIGTERM`) and macros (`SIG_DFL`, `SIG_IGN`, `SIG_ERR`).
  - Web/Wasm builds gracefully fall back to returning `null` or throwing `UnsupportedError` through the `io_stub.dart` architecture.
- **File System Operations Expansion (`<stdio.h>`)**: Completed the suite of C89 file lifecycle and error reporting functions.
  - Added `remove()` for file deletion and `rename()` for file relocation.
  - Implemented `perror()` to output standardized error messages to `stderr`.
  - Added `tmpnam()` for generating unique temporary file names, and `tmpfile()` for generating binary files (`wb+`) that are automatically deleted upon calling `fclose()`.

## v1.1.2 - May 16th 2026

- **Environment & Process Control**: Expanded `<stdlib.h>` to include essential environment and process utilities (`getenv`, `system`, `exit`, `abort`).
- **Cross-Platform Safety**: Implemented process control utilizing the `io_native`/`io_stub` architecture. Native builds map commands seamlessly to `dart:io` `Platform` and `Process` interfaces, while Web/Wasm builds gracefully fall back to returning `null` or throwing `UnsupportedError`.
- **System Execution**: `system()` routes directly to `Process.runSync` executing within the system shell, enabling literal C-style shell execution in native Dart environments. `abort()` correctly maps to `exit(1)`.
- **Standard Exit Macros**: Added `EXIT_SUCCESS` and `EXIT_FAILURE` macros to `<stdlib.h>`.

## v1.1.1 - May 14th 2026

- **Comprehensive File I/O Support**: Massively expanded `<stdio.h>` by bringing authentic C-style file handling to Dart. This update allows C code utilizing standard file operations to be ported with zero friction.
- **`FILE` and Constants**: Added the opaque `FILE` wrapper class along with core I/O constants: `EOF`, `SEEK_SET`, `SEEK_CUR`, and `SEEK_END`.
- **File Management**: Implemented `fopen`, `fclose`, and `fflush` for robust file lifecycle management.
- **Binary & Text I/O**: Added full read/write capabilities via `fread` and `fwrite`, seamlessly mapping to Dart's `RandomAccessFile` while maintaining C semantics.
- **Formatted File I/O**: Introduced `fprintf`, leveraging the existing `vprintf` engine to write formatted strings directly to file streams.
- **File Positioning**: Provided precise cursor control with `fseek`, `ftell`, and `rewind`.
- **Cross-Platform & Web Integrity**: Preserved zero-overhead Wasm and Web compilation. File operations dynamically fall back to safe `UnsupportedError` throws when executed in a web environment, adhering strictly to the `io_stub.dart` architecture.

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

# stdc

<p align="center">
  <b>A zero-friction, minimal-abstraction Standard C Library implementation for Dart.</b>
</p>

---

Designed specifically for C and C++ programmers who want to bring their muscle memory and familiar toolkit into the Dart ecosystem. `stdc` provides an authentic C experience without forcing you to learn new, convoluted abstractions.

## ⚡ The Selling Point: Zero Overhead, True Native Performance

You might be wondering: *Is this just a slow wrapper mimicking C?*

**Absolutely not.**

When you call a function like `stdc.sin(x)`, you aren't running a slow Dart approximation. Because `stdc` leverages Dart's VM intrinsics, your code directly compiles down to the exact same highly-optimized native `libc` (or `libm`) instructions that a standard C program would execute. 

## 🚀 Getting Started

To install the library, run the following command in your terminal:

**For Dart projects:**
```bash
dart pub add stdc
```

**For Flutter projects:**
```bash
flutter pub add stdc
```

*(Alternatively, you can manually add `stdc: ^1.0.5` to your `pubspec.yaml` dependencies).*

- **Zero Memory Overhead:** The `stdc` namespace is a compile-time constant. It allocates exactly `0` bytes.
- **Bare-Metal Speed:** You get the exact same precision, hardware acceleration, and speed as native C.
- **Familiar Architecture:** No object instantiation, no complex managers. Just pure, functional C calls.

## 🧠 The Philosophy

The beauty of `stdc` lies in its simplicity. You only need to remember one word: **`stdc`**.

Instead of dealing with fragmented namespaces like `stdio.printf` or `io.printf`, everything is directly accessible through the unified `stdc` interface. If you know C, you already know how to use this library.

```dart
import 'package:stdc/stdio.dart';
import 'package:stdc/math.dart';

void main() {
  // Classic C-style I/O
  stdc.printf("Hello, %s!\n", ["World"]);

  // Raw, native-speed mathematics
  double result = stdc.pow(2.0, 8.0);
}
```


### 📦 How to Import

There are two ways to use this library, depending on your preference:

#### 1. The "Include All" Approach (Convenience)
Import the main entry point to access all available C headers at once.
```dart
import 'package:stdc/stdc.dart';

void main() {
  var num = stdc.sqrt(16.0); 
}
```

#### 2. The "Specific Header" Approach (Authentic C Style)
Import only the specific headers you need, just like `#include <math.h>` in C. This keeps your autocomplete clean and only exposes the functions you intend to use.
```dart
import 'package:stdc/math.dart';
// import 'package:stdc/stdio.dart'; // (When implemented)

void main() {
  var num = stdc.sqrt(16.0); 
}
```
## 🛠 Supported Headers

We are actively expanding our coverage of standard C headers. Currently supported or in development:

- ✅ `<math.h>` - Core mathematical functions (`sin`, `pow`, `fabs`, `sqrt`, etc.)
- ✅ `<stdio.h>` - Standard input/output functions (`printf`, `sprintf`, `puts`, `getchar`, etc.)
- ✅ `<stdlib.h>` - Standard library utility functions (`atoi`, `rand`, `abs`, `qsort`, etc.)
- ✅ `<string.h>` - C-style string manipulation (`strcpy`, `strlen`, `strcmp`, etc.)
- ✅ `<ctype.h>` - Character classification (`isalpha`, `isdigit`, `toupper`, etc.)
- ✅ `<time.h>` - Core time tracking utilities (`time`, `clock`, `difftime`)
- ✅ `<assert.h>` - Standard C-style runtime assertions (`assert`)
- ✅ `<limits.h>` - Core integer limit boundaries (`INT_MAX`, `UINT_MAX`, etc.)
- ✅ `<float.h>` - Floating point limit bounds and epsilons (`DBL_MAX`, `FLT_EPSILON`, etc.)
- ✅ `<errno.h>` - Standard C error handling via `errno` macro representation
- ✅ `<stdint.h>` - Standard fixed-width integer types (`int8_t`, `uint32_t`, etc.)
- ✅ `<stdbool.h>` - Boolean utilities. (Note: Non-standard derived APIs start with an **Uppercase** letter)
- ✅ `<stddef.h>` - Standard type definitions like `size_t`, `ptrdiff_t`, and `NULL`
- ✅ `<complex.h>` - Complex number arithmetic and math functions (`cabs`, `cexp`, `csqrt`, etc.)
- ✅ `<inttypes.h>` - Extended integer formatting and conversion functions (`strtoimax`, `imaxabs`, etc.)
- ✅ `<uchar.h>` - Unicode and wide character utilities (`char16_t`, `mbrtoc16`, etc.)
- ✅ `<locale.h>` - Localization utilities (`setlocale`, `localeconv`, `Lconv`)
- ✅ `<wchar.h>` - Wide character string manipulation (`wcslen`, `wcscpy`, `wchar_t`, etc.)
- ✅ `<wctype.h>` - Wide character classification (`iswalpha`, `towlower`, etc.)


---

<p align="center">
  <i>"Why learn a new standard library when you already mastered the best one?"</i>
</p>

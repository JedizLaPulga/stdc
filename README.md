# stdc


A zero-friction, minimal-abstraction Standard C Library implementation for Dart.

Designed specifically for C programmers who want to bring their familiar toolkit into the Dart ecosystem. `stdc` provides an authentic C experience without forcing you to learn new, convoluted abstractions.

## The Philosophy

The beauty of `stdc` lies in its simplicity. You only need to remember one word: **`stdc`**.

Instead of dealing with fragmented namespaces like `stdio.printf` or `io.printf`, everything is directly accessible through the unified `stdc` interface. If you know C, you already know how to use this library.

```dart
import 'package:stdc/stdio.dart';

void main() {
  stdc.printf("Hello, %s!\n", ["World"]);
}
```

## Features (Coming Soon)

We are working on bringing all the standard headers you know and love:

- `<stdio.h>` - Standard input/output functions (`printf`, `sprintf`, etc.)
- `<stdlib.h>` - Standard library utility functions (`malloc`, `free`, `atoi`, etc.)
- `<string.h>` - C-style string manipulation (`strcpy`, `strlen`, etc.)
- `<math.h>` - Mathematical functions

## Getting Started

Add it to your `pubspec.yaml`:

```yaml
dependencies:
  stdc: ^1.0.0
```

Import the headers you need and start writing C-style Dart!

```dart
import 'package:stdc/stdio.dart';
import 'package:stdc/string.dart';

void main() {
  var dest = stdc.strcpy("C programmers ", "welcome to Dart!");
  stdc.printf("%s\n", [dest]);
}
```

// The core underlying base for the `stdc` library.
// 
// This provides the `Stdc` class and the singleton `stdc` instance
// that all other headers (like `math.dart`) will attach their
// extension methods to.

/// The base class for the `stdc` global namespace.
/// 
/// This class is intentionally empty. All standard C library 
/// functions are attached to this class via Dart extension methods 
/// in their respective header files (e.g. `package:stdc/math.dart`).
class Stdc {
  /// Constant constructor to allow for a single global const instance.
  const Stdc();
}

/// The global `stdc` instance. 
/// 
/// Use this object to access all imported standard library functions 
/// seamlessly, mimicking the standard C experience.
/// 
/// Example: 
/// ```dart
/// import 'package:stdc/math.dart';
/// 
/// void main() {
///   double result = stdc.sin(1.0);
/// }
/// ```
const stdc = Stdc();

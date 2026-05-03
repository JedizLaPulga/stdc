// The core underlying base for the `stdc` library.
// 
// This provides the `Stdc` class and the singleton `stdc` instance
// that all other headers (like `math.dart`) will attach their
// extension methods to.

class Stdc {
  // Constant constructor to allow for a single global const instance
  const Stdc();
}

/// The global `stdc` object. 
/// Use this to access all standard library functions seamlessly.
/// 
/// Example: `stdc.sin(1.0)`
const stdc = Stdc();

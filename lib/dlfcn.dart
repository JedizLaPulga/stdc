// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'dart:ffi';
import 'src/stdc_base.dart';

/// Extension providing `<dlfcn.h>` functionality.
extension StdcDlfcn on Stdc {
  /// Relocations are performed at an implementation-defined time.
  int get RTLD_LAZY => 1;

  /// Relocations are performed when the object is loaded.
  int get RTLD_NOW => 2;

  /// All symbols are available for relocation processing of other modules.
  int get RTLD_GLOBAL => 256;

  /// All symbols are not made available for relocation processing by other modules.
  int get RTLD_LOCAL => 0;

  static String? _lastError;

  /// Loads the dynamic library file named by the null-terminated string [filename]
  /// and returns an opaque "handle" for the dynamic library.
  /// 
  /// If [filename] is null, it returns a handle for the main program (like `DynamicLibrary.process()`).
  /// [flag] can be a combination of [RTLD_LAZY], [RTLD_NOW], [RTLD_GLOBAL], [RTLD_LOCAL].
  DynamicLibrary? dlopen(String? filename, int flag) {
    try {
      _lastError = null;
      if (filename == null) {
        return DynamicLibrary.process();
      } else {
        return DynamicLibrary.open(filename);
      }
    } catch (e) {
      _lastError = e.toString();
      return null;
    }
  }

  /// Returns a human-readable string describing the most recent error
  /// that occurred from `dlopen()`, `dlsym()` or `dlclose()` since
  /// the last call to `dlerror()`.
  String? dlerror() {
    final err = _lastError;
    _lastError = null;
    return err;
  }

  /// Takes a "handle" of a dynamic library returned by `dlopen()`
  /// and the null-terminated [symbol] name, returning the address
  /// where that symbol is loaded into memory.
  Pointer<T>? dlsym<T extends NativeType>(DynamicLibrary handle, String symbol) {
    try {
      _lastError = null;
      return handle.lookup<T>(symbol);
    } catch (e) {
      _lastError = e.toString();
      return null;
    }
  }

  /// Decrements the reference count on the dynamic library [handle].
  /// Note: `dart:ffi` does not currently provide a way to explicitly close a `DynamicLibrary`.
  /// This function acts as a no-op but returns `0` for success.
  int dlclose(DynamicLibrary handle) {
    _lastError = null;
    return 0; // Success
  }
}

import 'dart:ffi';
import 'package:stdc/stdc.dart' hide group;
import 'package:test/test.dart';

void main() {
  group('<dlfcn.h>', () {
    test('dlopen with null filename (process)', () {
      final handle = stdc.dlopen(null, stdc.RTLD_LAZY);
      expect(handle, isNotNull);
      expect(handle, isA<DynamicLibrary>());
      expect(stdc.dlerror(), isNull);
      
      int res = stdc.dlclose(handle!);
      expect(res, equals(0));
    });

    test('dlopen with non-existent library', () {
      final handle = stdc.dlopen("this_library_does_not_exist_ever.so", stdc.RTLD_LAZY);
      expect(handle, isNull);
      
      final err = stdc.dlerror();
      expect(err, isNotNull);
      expect(err!.contains('this_library_does_not_exist_ever'), isTrue);
      
      // Subsequent dlerror should be null
      expect(stdc.dlerror(), isNull);
    });

    test('dlsym failure returns null and sets dlerror', () {
      final handle = stdc.dlopen(null, stdc.RTLD_LAZY);
      expect(handle, isNotNull);
      
      final ptr = stdc.dlsym<Void>(handle!, "non_existent_symbol_12345");
      expect(ptr, isNull);
      
      final err = stdc.dlerror();
      expect(err, isNotNull);
      expect(err!.contains('non_existent_symbol_12345'), isTrue);
    });
  });
}

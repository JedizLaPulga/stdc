import 'dart:io';
import 'package:stdc/stdc.dart' hide group;
import 'package:test/test.dart';

void main() {
  group('<glob.h>', () {
    test('glob basic', () {
      // Create some dummy files to glob
      final tempDir = Directory.systemTemp.createTempSync('stdc_glob_test');
      File('${tempDir.path}/a.txt').createSync();
      File('${tempDir.path}/b.txt').createSync();
      File('${tempDir.path}/c.c').createSync();

      final originalDir = Directory.current;
      Directory.current = tempDir;

      final pglob = glob_t();
      
      try {
        int res = stdc.glob("*.txt", 0, null, pglob);
        expect(res, equals(0));
        expect(pglob.gl_pathc, equals(2));
        expect(pglob.gl_pathv, contains('a.txt'));
        expect(pglob.gl_pathv, contains('b.txt'));
        expect(pglob.gl_pathv, isNot(contains('c.c')));

        stdc.globfree(pglob);
        expect(pglob.gl_pathc, equals(0));
        expect(pglob.gl_pathv.isEmpty, isTrue);

        // GLOB_NOCHECK
        res = stdc.glob("*.nonexistent", stdc.GLOB_NOCHECK, null, pglob);
        expect(res, equals(0));
        expect(pglob.gl_pathc, equals(1));
        expect(pglob.gl_pathv, contains('*.nonexistent'));

      } finally {
        Directory.current = originalDir;
        tempDir.deleteSync(recursive: true);
      }
    });
  });
}

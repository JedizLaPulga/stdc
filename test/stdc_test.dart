import 'package:stdc/stdc.dart';
import 'package:test/test.dart';
import 'dart:io' as io;

void main() {
  group('math.h', () {
    test('sqrt', () {
      expect(stdc.sqrt(16.0), equals(4.0));
      expect(stdc.sqrt(2.0), closeTo(1.414, 0.001));
    });

    test('pow', () {
      expect(stdc.pow(2.0, 3.0), equals(8.0));
      expect(stdc.pow(5.0, 2.0), equals(25.0));
    });

    test('sin, cos, tan', () {
      // 0 radians
      expect(stdc.sin(0.0), equals(0.0));
      expect(stdc.cos(0.0), equals(1.0));
      expect(stdc.tan(0.0), equals(0.0));
    });

    test('fabs and abs', () {
      expect(stdc.fabs(-5.5), equals(5.5));
      expect(stdc.fabs(3.14), equals(3.14));
      
      expect(stdc.abs(-10), equals(10));
      expect(stdc.abs(42), equals(42));
    });

    test('ceil and floor', () {
      expect(stdc.ceil(3.14), equals(4.0));
      expect(stdc.floor(3.14), equals(3.0));
      
      expect(stdc.ceil(-3.14), equals(-3.0));
      expect(stdc.floor(-3.14), equals(-4.0));
    });

    test('fmod, fmax, fmin', () {
      expect(stdc.fmod(5.5, 2.0), equals(1.5));
      expect(stdc.fmax(3.0, 5.0), equals(5.0));
      expect(stdc.fmin(3.0, 5.0), equals(3.0));
    });

    test('hypot, round, trunc, cbrt', () {
      expect(stdc.hypot(3.0, 4.0), equals(5.0));
      expect(stdc.round(3.6), equals(4.0));
      expect(stdc.trunc(3.6), equals(3.0));
      expect(stdc.cbrt(8.0), closeTo(2.0, 0.001));
      expect(stdc.cbrt(-8.0), closeTo(-2.0, 0.001));
    });
  });

  group('stdarg.h and stdio.dart', () {
    test('va_list operations', () {
      var ap = stdc.va_start(['hello', 42, 3.14]);
      
      expect(stdc.va_arg<String>(ap), equals('hello'));
      expect(stdc.va_arg<int>(ap), equals(42));
      
      var apCopy = stdc.va_start([]);
      stdc.va_copy(apCopy, ap);
      
      expect(stdc.va_arg<double>(ap), equals(3.14));
      expect(() => stdc.va_arg<dynamic>(ap), throwsA(isA<StateError>()));
      
      // Copy should still have the 3.14 to pop
      expect(stdc.va_arg<double>(apCopy), equals(3.14));
      
      stdc.va_end(ap);
      stdc.va_end(apCopy);
    });

    test('vsprintf', () {
      var ap = stdc.va_start([42, 'world']);
      String result = stdc.vsprintf('Hello %d %s', ap);
      expect(result, equals('Hello 42 world'));
      stdc.va_end(ap);
    });

    test('sprintf uses vsprintf properly', () {
      expect(stdc.sprintf('Test %d', [100]), equals('Test 100'));
    });
  });

  group('File I/O', () {
    final testFilePath = 'test_io.txt';

    tearDown(() {
      final file = io.File(testFilePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('fopen, fwrite, fclose', () {
      var file = stdc.fopen(testFilePath, 'w');
      expect(file, isNotNull);

      var data = 'Hello, stdc!'.codeUnits;
      int written = stdc.fwrite(data, 1, data.length, file!);
      expect(written, equals(data.length));

      int result = stdc.fclose(file);
      expect(result, equals(0));

      expect(io.File(testFilePath).readAsStringSync(), equals('Hello, stdc!'));
    });

    test('fopen, fread, fseek, ftell', () {
      io.File(testFilePath).writeAsStringSync('0123456789');

      var file = stdc.fopen(testFilePath, 'r');
      expect(file, isNotNull);

      expect(stdc.ftell(file!), equals(0));

      var buffer = List<int>.filled(5, 0);
      int read = stdc.fread(buffer, 1, 5, file);
      expect(read, equals(5));
      expect(String.fromCharCodes(buffer), equals('01234'));

      expect(stdc.ftell(file), equals(5));

      stdc.fseek(file, 2, stdc.SEEK_SET);
      expect(stdc.ftell(file), equals(2));

      read = stdc.fread(buffer, 1, 3, file);
      expect(read, equals(3));
      expect(String.fromCharCodes(buffer.sublist(0, 3)), equals('234'));

      stdc.fclose(file);
    });

    test('fprintf', () {
      var file = stdc.fopen(testFilePath, 'w');
      expect(file, isNotNull);

      int written = stdc.fprintf(file!, 'Value: %d', [42]);
      expect(written, greaterThan(0));

      stdc.fclose(file);
      expect(io.File(testFilePath).readAsStringSync(), equals('Value: 42'));
    });

    test('remove and rename', () {
      final oldFile = 'old_test.txt';
      final newFile = 'new_test.txt';
      io.File(oldFile).writeAsStringSync('data');
      
      expect(stdc.rename(oldFile, newFile), equals(0));
      expect(io.File(oldFile).existsSync(), isFalse);
      expect(io.File(newFile).existsSync(), isTrue);
      
      expect(stdc.remove(newFile), equals(0));
      expect(io.File(newFile).existsSync(), isFalse);
    });

    test('tmpnam and tmpfile', () {
      final name = stdc.tmpnam();
      expect(name, isNotEmpty);
      
      var buffer = List<int>.filled(256, 0);
      final name2 = stdc.tmpnam(buffer);
      expect(name2, isNotEmpty);
      expect(buffer[0], isNot(equals(0)));

      final temp = stdc.tmpfile();
      expect(temp, isNotNull);
      stdc.fprintf(temp!, 'Temp data');
      stdc.fflush(temp);
      stdc.fclose(temp);
    });
  });

  group('stdlib.h process control', () {
    test('macros', () {
      expect(stdc.EXIT_SUCCESS, equals(0));
      expect(stdc.EXIT_FAILURE, equals(1));
    });

    test('getenv', () {
      // PATH is almost universally present on native test environments
      expect(stdc.getenv('PATH'), isNotNull);
      expect(stdc.getenv('NON_EXISTENT_VAR_12345'), isNull);
    });

    test('system', () {
      // Run a simple command that should succeed
      int exitCode = stdc.system('dart --version');
      expect(exitCode, equals(0));
    });
  });

  group('signal.h', () {
    test('signal and raise', () {
      bool caught = false;
      void handler(int sig) {
        caught = true;
      }
      
      // Register custom handler
      var prev = stdc.signal(stdc.SIGINT, handler);
      expect(prev, equals(stdc.SIG_DFL));
      
      // Raise the signal manually
      stdc.raise(stdc.SIGINT);
      expect(caught, isTrue);
      
      // Ignore signal
      stdc.signal(stdc.SIGINT, stdc.SIG_IGN);
      caught = false;
      stdc.raise(stdc.SIGINT);
      expect(caught, isFalse);
      
      // Restore default handler
      stdc.signal(stdc.SIGINT, stdc.SIG_DFL);
    });
  });

  group('setjmp.h', () {
    test('setjmp and longjmp basic', () {
      final env = jmp_buf();
      int executionCount = 0;
      
      int result = stdc.setjmp(env, () {
        executionCount++;
        stdc.longjmp(env, 42);
      });
      
      expect(result, equals(42));
      expect(executionCount, equals(1));
    });

    test('setjmp normal return', () {
      final env = jmp_buf();
      int result = stdc.setjmp(env, () {
        // do nothing
      });
      expect(result, equals(0));
    });

    test('longjmp with 0 returns 1', () {
      final env = jmp_buf();
      int result = stdc.setjmp(env, () {
        stdc.longjmp(env, 0);
      });
      expect(result, equals(1));
    });
  });

  group('dirent.h', () {
    test('opendir, readdir, closedir', () {
      final dirName = 'test_dir_dirent';
      final dir = io.Directory(dirName);
      dir.createSync();
      io.File('$dirName/file1.txt').writeAsStringSync('1');
      io.File('$dirName/file2.txt').writeAsStringSync('2');

      final dirp = stdc.opendir(dirName);
      expect(dirp, isNotNull);

      var entries = <String>[];
      dirent? entry;
      while ((entry = stdc.readdir(dirp)) != null) {
        entries.add(entry!.d_name);
      }

      expect(entries.length, equals(2));
      expect(entries.contains('file1.txt'), isTrue);
      expect(entries.contains('file2.txt'), isTrue);

      stdc.rewinddir(dirp);
      var entryAfterRewind = stdc.readdir(dirp);
      expect(entryAfterRewind, isNotNull);

      expect(stdc.closedir(dirp), equals(0));
      expect(stdc.readdir(dirp), isNull);

      dir.deleteSync(recursive: true);
    });
  });
}

import 'package:test/test.dart';
import 'package:stdc/stdc.dart';

void main() {
  group('getopt.h', () {
    setUp(() {
      stdc.optreset();
      stdc.opterr = 0; // Prevent stderr prints during testing
    });

    test('getopt basic short options', () {
      final argv = ['prog', '-a', '-b', 'value', '-c'];
      int argc = argv.length;

      expect(stdc.getopt(argc, argv, "ab:c"), equals('a'.codeUnitAt(0)));
      expect(stdc.getopt(argc, argv, "ab:c"), equals('b'.codeUnitAt(0)));
      expect(stdc.optarg, equals('value'));
      expect(stdc.getopt(argc, argv, "ab:c"), equals('c'.codeUnitAt(0)));
      expect(stdc.getopt(argc, argv, "ab:c"), equals(-1));
    });

    test('getopt grouped short options', () {
      final argv = ['prog', '-acbvalue'];
      int argc = argv.length;

      expect(stdc.getopt(argc, argv, "ab:c"), equals('a'.codeUnitAt(0)));
      expect(stdc.getopt(argc, argv, "ab:c"), equals('c'.codeUnitAt(0)));
      expect(stdc.getopt(argc, argv, "ab:c"), equals('b'.codeUnitAt(0)));
      expect(stdc.optarg, equals('value'));
      expect(stdc.getopt(argc, argv, "ab:c"), equals(-1));
    });

    test('getopt missing argument', () {
      final argv = ['prog', '-b'];
      int argc = argv.length;

      expect(stdc.getopt(argc, argv, "ab:c"), equals('?'.codeUnitAt(0)));
      expect(stdc.optopt, equals('b'.codeUnitAt(0)));
      
      stdc.optreset();
      stdc.opterr = 0;
      expect(stdc.getopt(argc, argv, ":ab:c"), equals(':'.codeUnitAt(0)));
      expect(stdc.optopt, equals('b'.codeUnitAt(0)));
    });

    test('getopt_long basic', () {
      final argv = ['prog', '--add', '--append', 'foo', '--delete=bar', '-c'];
      int argc = argv.length;

      final longopts = [
        Option('add', no_argument, null, 1),
        Option('append', required_argument, null, 2),
        Option('delete', required_argument, null, 3),
        Option('create', optional_argument, null, 4),
      ];

      final longindex = [0];

      expect(stdc.getopt_long(argc, argv, "c", longopts, longindex), equals(1));
      expect(longindex[0], equals(0));

      expect(stdc.getopt_long(argc, argv, "c", longopts, longindex), equals(2));
      expect(stdc.optarg, equals('foo'));
      expect(longindex[0], equals(1));

      expect(stdc.getopt_long(argc, argv, "c", longopts, longindex), equals(3));
      expect(stdc.optarg, equals('bar'));
      expect(longindex[0], equals(2));

      expect(stdc.getopt_long(argc, argv, "c", longopts, longindex), equals('c'.codeUnitAt(0)));

      expect(stdc.getopt_long(argc, argv, "c", longopts, longindex), equals(-1));
    });

    test('getopt_long with flag', () {
      final argv = ['prog', '--verbose'];
      int argc = argv.length;
      final verboseFlag = [0];

      final longopts = [
        Option('verbose', no_argument, verboseFlag, 1),
      ];

      expect(stdc.getopt_long(argc, argv, "", longopts), equals(0));
      expect(verboseFlag[0], equals(1));
    });
  });
}

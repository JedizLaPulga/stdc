import 'package:stdc/stdc.dart' hide group;
import 'package:test/test.dart';
import 'dart:async';

void main() {
  group('<syslog.h>', () {
    test('openlog, syslog, closelog', () {
      final prints = <String>[];
      runZoned(() {
        stdc.openlog("my_app", stdc.LOG_PID, stdc.LOG_USER);
        stdc.syslog(stdc.LOG_INFO, "This is an info message.");
        stdc.closelog();
      }, zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
          prints.add(line);
        },
      ));

      expect(prints.length, equals(1));
      expect(prints[0], equals('<6> my_app: This is an info message.'));
    });

    test('setlogmask filters messages', () {
      final prints = <String>[];
      runZoned(() {
        stdc.openlog("my_app", 0, stdc.LOG_USER);
        
        // Only allow ERR and higher
        stdc.setlogmask(stdc.LOG_UPTO(stdc.LOG_ERR));
        
        stdc.syslog(stdc.LOG_INFO, "This should be filtered.");
        stdc.syslog(stdc.LOG_ERR, "This should be printed.");
        
        stdc.closelog();
      }, zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
          prints.add(line);
        },
      ));

      expect(prints.length, equals(1));
      expect(prints[0], equals('<3> my_app: This should be printed.'));
    });
  });
}

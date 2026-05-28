import 'package:stdc/stdc.dart';
import 'package:test/test.dart';

void main() {
  group('time', () {
    test('time returns a valid unix timestamp', () {
      int t = stdc.time();
      expect(t, greaterThan(0));
    });

    test('clock progresses', () async {
      int c1 = stdc.clock();
      await Future.delayed(Duration(milliseconds: 50));
      int c2 = stdc.clock();
      expect(c2, greaterThanOrEqualTo(c1));
    });

    test('difftime calculates difference', () {
      expect(stdc.difftime(100, 50), 50.0);
    });

    test('Tm fromDateTime and toDateTime', () {
      var dt = DateTime(2023, 10, 5, 14, 30, 45);
      var tm = Tm.fromDateTime(dt);
      expect(tm.tm_year, equals(123)); // 2023 - 1900
      expect(tm.tm_mon, equals(9)); // October is 9
      expect(tm.tm_mday, equals(5));
      expect(tm.tm_hour, equals(14));
      expect(tm.tm_min, equals(30));
      expect(tm.tm_sec, equals(45));
      
      var dt2 = tm.toDateTime(isUtc: false);
      expect(dt2.year, equals(2023));
    });

    test('localtime and gmtime', () {
      var tm = stdc.localtime(1696516245); 
      expect(tm.tm_year, equals(123)); // 2023

      var gmtm = stdc.gmtime(1696516245);
      expect(gmtm.tm_year, equals(123));
    });

    test('mktime', () {
      var tm = Tm(tm_year: 123, tm_mon: 9, tm_mday: 5, tm_hour: 14, tm_min: 30, tm_sec: 45);
      int t = stdc.mktime(tm);
      expect(t, greaterThan(0));
    });

    test('asctime', () {
      var tm = Tm(tm_year: 123, tm_mon: 9, tm_mday: 5, tm_hour: 14, tm_min: 30, tm_sec: 45, tm_wday: 4);
      var str = stdc.asctime(tm);
      expect(str, equals('Thu Oct  5 14:30:45 2023\n'));
    });

    test('strftime', () {
      var tm = Tm(tm_year: 123, tm_mon: 9, tm_mday: 5, tm_hour: 14, tm_min: 30, tm_sec: 45, tm_wday: 4);
      expect(stdc.strftime('%Y-%m-%d %H:%M:%S', tm), equals('2023-10-05 14:30:45'));
    });
  });
}

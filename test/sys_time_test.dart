import 'package:test/test.dart';
import 'package:stdc/stdc.dart' hide group;

void main() {
  group('sys/time.h', () {
    test('gettimeofday populates tv_sec and tv_usec', () {
      final tv = TimeVal();
      final result = stdc.gettimeofday(tv);
      
      expect(result, 0);
      expect(tv.tv_sec, isPositive);
      expect(tv.tv_usec, inInclusiveRange(0, 999999));

      // Ensure that the time is roughly correct by comparing with DateTime.now
      final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      expect((tv.tv_sec - nowSeconds).abs(), lessThanOrEqualTo(2));
    });

    test('gettimeofday with timezone', () {
      final tv = TimeVal();
      final tz = TimeZone();
      final result = stdc.gettimeofday(tv, tz);
      
      expect(result, 0);
      // Depending on local timezone, tz_minuteswest could be anything, but it shouldn't throw.
      expect(tz.tz_minuteswest, equals(-DateTime.now().timeZoneOffset.inMinutes));
    });
  });
}

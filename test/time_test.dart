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
  });
}

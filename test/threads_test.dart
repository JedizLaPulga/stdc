import 'package:test/test.dart';
import 'package:stdc/stdc.dart' hide group;

void main() {
  group('threads.h', () {
    test('mtx_init and lock', () {
      final mtx = mtx_t();
      expect(stdc.mtx_init(mtx, mtx_plain), equals(thrd_success));
      expect(mtx.locked, isFalse);

      expect(stdc.mtx_lock(mtx), equals(thrd_success));
      expect(mtx.locked, isTrue);

      expect(stdc.mtx_unlock(mtx), equals(thrd_success));
      expect(mtx.locked, isFalse);
    });

    test('thrd_join returns error', () {
      final thr = thrd_t();
      expect(stdc.thrd_join(thr, null), equals(thrd_error));
    });
  });
}

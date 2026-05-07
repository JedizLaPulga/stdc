import 'package:test/test.dart';
import 'package:stdc/stdc.dart';

void main() {
  group('stdint.h', () {
    test('extension types and typedefs', () {
      int8_t a = 10;
      Int8 b = Int8(10);
      
      expect(a, 10);
      expect(b, 10);
      // Since b implements int
      expect(b as int, 10);
    });

    test('constants', () {
      expect(stdc.INT8_MAX, 127);
      expect(stdc.INT8_MIN, -128);
      expect(stdc.UINT8_MAX, 255);
      
      expect(stdc.INT32_MAX, 2147483647);
      expect(stdc.INT32_MIN, -2147483648);
      expect(stdc.UINT32_MAX, 4294967295);
      
      expect(stdc.INT64_MAX, 9223372036854775807);
      expect(stdc.INT64_MIN, -9223372036854775808);
    });
  });
}

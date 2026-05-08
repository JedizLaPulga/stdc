import 'package:test/test.dart';
import 'package:stdc/stdc.dart';

void main() {
  group('<uchar.h>', () {
    test('mbrtoc16 and c16rtomb', () {
      var bytes = stdc.c16rtomb(65); // 'A'
      expect(bytes, equals([65]));
      expect(stdc.mbrtoc16(bytes), equals(65));
    });

    test('mbrtoc32 and c32rtomb', () {
      // 128512 is 😀 (U+1F600)
      var bytes = stdc.c32rtomb(128512);
      expect(bytes, isNotEmpty);
      expect(stdc.mbrtoc32(bytes), equals(128512));
    });
  });
}

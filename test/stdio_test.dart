import 'package:stdc/stdc.dart';
import 'package:test/test.dart';

void main() {
  group('stdio', () {
    test('sprintf formats strings correctly', () {
      expect(stdc.sprintf("Hello %s!", ["World"]), "Hello World!");
      expect(stdc.sprintf("Number: %d", [42]), "Number: 42");
      expect(stdc.sprintf("Hex: %x and %X", [255, 255]), "Hex: ff and FF");
      expect(stdc.sprintf("Float: %f", [3.14159]), "Float: 3.141590");
      expect(stdc.sprintf("Char: %c", [65]), "Char: A");
      expect(stdc.sprintf("Literal %%"), "Literal %");
    });
  });
}

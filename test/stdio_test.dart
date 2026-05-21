import 'package:stdc/stdc.dart';
import 'package:test/test.dart';

void main() {
  group('stdio - sprintf (pre-existing specifiers)', () {
    test('basic string, int, hex, float, char, literal %%', () {
      expect(stdc.sprintf('Hello %s!', ['World']), 'Hello World!');
      expect(stdc.sprintf('Number: %d', [42]), 'Number: 42');
      expect(stdc.sprintf('Hex: %x and %X', [255, 255]), 'Hex: ff and FF');
      expect(stdc.sprintf('Float: %f', [3.14159]), 'Float: 3.141590');
      expect(stdc.sprintf('Char: %c', [65]), 'Char: A');
      expect(stdc.sprintf('Literal %%'), 'Literal %');
    });
  });

  group('stdio - vsprintf flags', () {
    test('%-: left-align within field width', () {
      expect(stdc.sprintf('|%-10s|', ['hi']), '|hi        |');
      expect(stdc.sprintf('|%-5d|', [42]), '|42   |');
    });

    test('%+: force sign on positive numbers', () {
      expect(stdc.sprintf('%+d', [42]), '+42');
      expect(stdc.sprintf('%+d', [-42]), '-42');
      expect(stdc.sprintf('%+f', [1.5]), '+1.500000');
    });

    test('% : space prefix when no sign', () {
      expect(stdc.sprintf('% d', [42]), ' 42');
      expect(stdc.sprintf('% d', [-42]), '-42');
    });

    test('%0: zero-padding', () {
      expect(stdc.sprintf('%05d', [42]), '00042');
      expect(stdc.sprintf('%08.3f', [3.14]), '0003.140');
      expect(stdc.sprintf('%010d', [-7]), '-000000007');
    });

    test('%#: alternate form for hex and octal', () {
      expect(stdc.sprintf('%#x', [255]), '0xff');
      expect(stdc.sprintf('%#X', [255]), '0XFF');
      expect(stdc.sprintf('%#o', [8]), '010');
      // zero value — # flag adds no prefix for zero
      expect(stdc.sprintf('%#x', [0]), '0');
    });
  });

  group('stdio - vsprintf width and precision', () {
    test('integer width', () {
      expect(stdc.sprintf('%10d', [42]), '        42');
      expect(stdc.sprintf('%-10d|', [42]), '42        |');
    });

    test('float precision', () {
      expect(stdc.sprintf('%.2f', [3.14159]), '3.14');
      expect(stdc.sprintf('%10.4f', [3.14159]), '    3.1416');
      expect(stdc.sprintf('%.0f', [3.7]), '4');
    });

    test('string precision (max chars)', () {
      expect(stdc.sprintf('%.3s', ['hello']), 'hel');
      expect(stdc.sprintf('%10.3s', ['hello']), '       hel');
    });

    test('width from argument (*)', () {
      expect(stdc.sprintf('%*d', [10, 42]), '        42');
      expect(stdc.sprintf('%*d', [-10, 42]), '42        ');
    });

    test('precision from argument (.*)', () {
      expect(stdc.sprintf('%.*f', [3, 3.14159]), '3.142');
    });
  });

  group('stdio - vsprintf new specifiers', () {
    test('%u unsigned decimal', () {
      expect(stdc.sprintf('%u', [42]), '42');
      expect(stdc.sprintf('%010u', [0]), '0000000000');
    });

    test('%o octal', () {
      expect(stdc.sprintf('%o', [8]), '10');
      expect(stdc.sprintf('%o', [255]), '377');
      expect(stdc.sprintf('%08o', [8]), '00000010');
    });

    test('%e scientific notation (lowercase)', () {
      expect(stdc.sprintf('%e', [12345.6789]), '1.234568e+04');
      expect(stdc.sprintf('%.2e', [0.001]), '1.00e-03');
      expect(stdc.sprintf('%e', [0.0]), '0.000000e+00');
    });

    test('%E scientific notation (uppercase)', () {
      expect(stdc.sprintf('%E', [12345.6789]), '1.234568E+04');
      expect(stdc.sprintf('%.2E', [0.001]), '1.00E-03');
    });

    test('%g shortest representation', () {
      // exponent >= precision → use %e style
      expect(stdc.sprintf('%g', [0.000123]), '0.000123');
      expect(stdc.sprintf('%g', [0.0000123]), '1.23e-05');
      // trailing zeros stripped
      expect(stdc.sprintf('%g', [100.0]), '100');
      expect(stdc.sprintf('%.2g', [1.5]), '1.5');
    });

    test('%G shortest representation (uppercase)', () {
      expect(stdc.sprintf('%G', [0.0000123]), '1.23E-05');
    });

    test('%p pointer (non-null, produces 0x prefix)', () {
      final s = stdc.sprintf('%p', ['dummy']);
      expect(s, startsWith('0x'));
    });
  });

  group('stdio - vsprintf combined', () {
    test('zero-pad + precision on float', () {
      // width=10: "+" + "000" + "3.1400" = 10 chars total
      expect(stdc.sprintf('%+010.4f', [3.14]), '+0003.1400');
    });

    test('alternate hex + zero-pad + width', () {
      expect(stdc.sprintf('%#010x', [255]), '0x000000ff');
    });

    test('left-align + precision on string', () {
      expect(stdc.sprintf('%-10.3s|', ['hello']), 'hel       |');
    });

    test('length modifiers are consumed and ignored', () {
      // %ld, %lld, %hd should all format the integer normally
      expect(stdc.sprintf('%ld', [42]), '42');
      expect(stdc.sprintf('%lld', [1000]), '1000');
      expect(stdc.sprintf('%hd', [7]), '7');
    });

    test('nan and inf render correctly', () {
      expect(stdc.sprintf('%f', [double.nan]), 'nan');
      expect(stdc.sprintf('%f', [double.infinity]), 'inf');
      expect(stdc.sprintf('%f', [double.negativeInfinity]), '-inf');
      expect(stdc.sprintf('%e', [double.nan]), 'nan');
      expect(stdc.sprintf('%g', [double.infinity]), 'inf');
    });
  });

  group('stdio - snprintf', () {
    test('no truncation when output fits', () {
      expect(stdc.snprintf(20, 'Hello %s!', ['World']), 'Hello World!');
    });

    test('truncates to n-1 characters', () {
      expect(stdc.snprintf(6, 'Hello, %s!', ['World']), 'Hello');
    });

    test('n=1 returns empty string', () {
      expect(stdc.snprintf(1, 'abc'), '');
    });

    test('n=0 returns empty string', () {
      expect(stdc.snprintf(0, 'abc'), '');
    });

    test('exact fit (n == length+1)', () {
      // "Hello" is 5 chars; n=6 allows all 5
      expect(stdc.snprintf(6, 'Hello'), 'Hello');
    });

    test('formats with full specifier support', () {
      expect(stdc.snprintf(10, '%08.3f', [3.14]), '0003.140');
    });
  });

  group('stdio - sscanf basics', () {
    test('parses int, double, string', () {
      final r = stdc.sscanf('42 3.14 hello', '%d %f %s');
      expect(r, [42, 3.14, 'hello']);
    });

    test('returns partial list on early mismatch', () {
      final r = stdc.sscanf('42 abc', '%d %d');
      expect(r, [42]);
    });

    test('matches literal characters', () {
      final r = stdc.sscanf('10,20', '%d,%d');
      expect(r, [10, 20]);
    });

    test('multiple ints', () {
      final r = stdc.sscanf('1 2 3 4', '%d %d %d %d');
      expect(r, [1, 2, 3, 4]);
    });
  });

  group('stdio - sscanf integer bases', () {
    test('%i auto-detects hex (0x prefix)', () {
      final r = stdc.sscanf('0xff', '%i');
      expect(r, [255]);
    });

    test('%i auto-detects octal (0 prefix)', () {
      final r = stdc.sscanf('010', '%i');
      expect(r, [8]);
    });

    test('%i decimal (no prefix)', () {
      final r = stdc.sscanf('99', '%i');
      expect(r, [99]);
    });

    test('%x hex without prefix', () {
      final r = stdc.sscanf('ff', '%x');
      expect(r, [255]);
    });

    test('%x hex with 0x prefix', () {
      final r = stdc.sscanf('0x1a', '%x');
      expect(r, [26]);
    });

    test('%o octal', () {
      final r = stdc.sscanf('17', '%o');
      expect(r, [15]);
    });

    test('%u unsigned', () {
      final r = stdc.sscanf('255', '%u');
      expect(r, [255]);
    });
  });

  group('stdio - sscanf float specifiers', () {
    test('%f parses decimal float', () {
      expect(stdc.sscanf('3.14', '%f'), [3.14]);
    });

    test('%e parses scientific notation', () {
      expect(stdc.sscanf('1.5e2', '%e'), [150.0]);
    });

    test('%g accepts both styles', () {
      expect(stdc.sscanf('0.001', '%g'), [0.001]);
      expect(stdc.sscanf('1e-3', '%g'), [0.001]);
    });
  });

  group('stdio - sscanf misc', () {
    test('%c reads single character', () {
      final r = stdc.sscanf('A', '%c');
      expect(r, ['A']);
    });

    test('%n stores chars consumed so far', () {
      final r = stdc.sscanf('hello world', '%s%n');
      expect(r[0], 'hello');
      expect(r[1], 5);
    });

    test('%% matches literal percent', () {
      final r = stdc.sscanf('100% done', '%d%%');
      expect(r, [100]);
    });

    test('width limits characters read', () {
      final r = stdc.sscanf('12345', '%3d');
      expect(r, [123]);
    });

    test('suppress-assignment %* discards value', () {
      final r = stdc.sscanf('10 20 30', '%d %*d %d');
      expect(r, [10, 30]);
    });

    test('whitespace in format matches any whitespace in input', () {
      final r = stdc.sscanf('1\t\n2', '%d %d');
      expect(r, [1, 2]);
    });
  });
}

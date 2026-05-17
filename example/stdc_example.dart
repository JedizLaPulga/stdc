import 'package:stdc/stdc.dart';

void mathEg() {
  print('--- stdc math.h examples ---');
  var number = 16.0;
  print('sqrt($number) = ${stdc.sqrt(number)}');

  var base = 2.0;
  var exponent = 8.0;
  print('pow($base, $exponent) = ${stdc.pow(base, exponent)}');

  var pi = 3.1415926535897932;
  print('sin(pi/2) = ${stdc.sin(pi / 2)}');

  print('abs(-42) = ${stdc.abs(-42)}');
  print('fabs(-3.14) = ${stdc.fabs(-3.14)}');

  print('ceil(2.3) = ${stdc.ceil(2.3)}');
  print('floor(2.8) = ${stdc.floor(2.8)}\n');
}

void ctypeEg() {
  print('--- stdc ctype.h examples ---');
  print('isalpha("A") = ${stdc.isalpha("A")}');
  print('isdigit("5") = ${stdc.isdigit("5")}');
  print('isspace(" ") = ${stdc.isspace(" ")}');
  print('ispunct("!") = ${stdc.ispunct("!")}');

  print('toupper("h") = ${stdc.toupper("h")}');
  print('tolower("G") = ${stdc.tolower("G")}\n');
}

void stringEg() {
  print('--- stdc string.h examples ---');
  print('strlen("hello") = ${stdc.strlen("hello")}');
  print('strcmp("apple", "banana") = ${stdc.strcmp("apple", "banana")}');
  
  print('strchr("hello", "e") = ${stdc.strchr("hello", "e")}');
  print('strstr("hello world", "world") = ${stdc.strstr("hello world", "world")}');
  
  String buffer = "hello";
  buffer = stdc.strcat(buffer, " world");
  print('strcat result = "$buffer"\n');
}

void stdlibEg() {
  print('--- stdc stdlib.h examples ---');
  print('atoi("42") = ${stdc.atoi("42")}');
  print('atof("3.14") = ${stdc.atof("3.14")}');
  
  stdc.srand(12345);
  print('rand() = ${stdc.rand()}');
  
  List<int> numbers = [5, 2, 9, 1, 5, 6];
  stdc.qsort(numbers, (a, b) => a.compareTo(b));
  print('qsort result = $numbers');

  print('getenv("PATH") exists? ${stdc.getenv("PATH") != null}');
  try {
    print('system("echo stdc execution test") exit code = ${stdc.system("echo stdc execution test")}');
  } catch (e) {
    print('system() not supported on this platform.');
  }
  print('');
}

void timeEg() {
  print('--- stdc time.h examples ---');
  int t = stdc.time();
  print('time() = $t');
  print('ctime(time()) = ${stdc.ctime(t)}');
  print('clock() = ${stdc.clock()} ms ticks since start\n');
}

void stdioEg() {
  print('--- stdc stdio.h examples ---');
  stdc.puts("This is printed using puts()!");
  stdc.printf("This is printed using printf()! Hello %s, number %d!\n", ["World", 100]);
  
  String formatted = stdc.sprintf("Hex format of 255 is 0x%X", [255]);
  print('Dart print() loves sprintf: $formatted');

  var file = stdc.fopen('stdc_test_file.txt', 'w');
  if (file != null) {
    stdc.fprintf(file, 'File I/O works seamlessly!\n');
    stdc.fclose(file);
    print('Successfully wrote to stdc_test_file.txt using fopen/fprintf/fclose\n');
  } else {
    print('fopen failed (perhaps running on web?)\n');
  }
}

void assertEg() {
  print('--- stdc assert.h examples ---');
  try {
    print('Calling stdc.assert_(true)');
    stdc.assert_(true);
    print('Calling stdc.assert_(false, "This should fail")');
    stdc.assert_(false, "This should fail");
  } catch (e) {
    print('Assertion caught: $e');
  }
  print('');
}

void limitsEg() {
  print('--- stdc limits.h examples ---');
  print('CHAR_BIT = ${stdc.CHAR_BIT}');
  print('INT_MAX = ${stdc.INT_MAX}');
  print('INT_MIN = ${stdc.INT_MIN}');
  print('LONG_MAX = ${stdc.LONG_MAX}\n');
}

void floatEg() {
  print('--- stdc float.h examples ---');
  print('FLT_DIG = ${stdc.FLT_DIG}');
  print('FLT_MAX = ${stdc.FLT_MAX}');
  print('DBL_DIG = ${stdc.DBL_DIG}');
  print('DBL_MAX = ${stdc.DBL_MAX}\n');
}

void errnoEg() {
  print('--- stdc errno.h examples ---');
  print('Initial errno = ${stdc.errno}');
  
  // Simulating an error
  stdc.errno = stdc.EDOM;
  print('After simulating domain error, errno = ${stdc.errno}');
  
  // Standard error macros
  print('EDOM = ${stdc.EDOM}');
  print('ERANGE = ${stdc.ERANGE}\n');
}

void stdintEg() {
  print('--- stdc stdint.h examples ---');
  int32_t val1 = 42;
  Int32 val2 = Int32(100);
  print('int32_t (typedef) = $val1');
  print('Int32 (strict type) = $val2');
  print('INT32_MAX = ${stdc.INT32_MAX}');
  print('UINT8_MAX = ${stdc.UINT8_MAX}\n');
}

void stdboolEg() {
  print('--- stdc stdbool.h examples ---');
  bool isCProgrammer = stdc.true_;
  print('Is C Programmer? $isCProgrammer');
  print('Toggled: ${isCProgrammer.Toggle()}');
  print('As integer (ToInt): ${isCProgrammer.ToInt()}\n');
}

void stddefEg() {
  print('--- stdc stddef.h examples ---');
  size_t stringLength = stdc.strlen("hello world");
  print('size_t used for strlen: $stringLength');
  print('stdc.NULL == null? ${stdc.NULL == null}\n');
}

void complexEg() {
  print('--- stdc complex.h examples ---');
  complex z = complex(3.0, 4.0);
  print('cabs(3.0 + 4.0i) = ${stdc.cabs(z)}');
  print('cexp(0 + pi*i) = ${stdc.cexp(complex(0.0, 3.141592653589793))}\n');
}

void inttypesEg() {
  print('--- stdc inttypes.h examples ---');
  print('imaxabs(-9223372036854775807) = ${stdc.imaxabs(-9223372036854775807)}');
  print('strtoimax("1A", radix: 16) = ${stdc.strtoimax("1A", radix: 16)}\n');
}

void ucharEg() {
  print('--- stdc uchar.h examples ---');
  var bytes = stdc.c32rtomb(128512); // 😀
  print('c32rtomb(128512) (UTF-8 bytes of 😀) = $bytes');
  print('mbrtoc32($bytes) = ${stdc.mbrtoc32(bytes)}\n');
}

void localeEg() {
  print('--- stdc locale.h examples ---');
  print('setlocale(LC_ALL, "C") = ${stdc.setlocale(stdc.LC_ALL, "C")}');
  var lconv = stdc.localeconv();
  print('localeconv().decimal_point = "${lconv.decimal_point}"\n');
}

void wcharEg() {
  print('--- stdc wchar.h examples ---');
  List<wchar_t> wcs = [104, 101, 108, 108, 111]; // "hello" in runes
  print('wcslen("hello") = ${stdc.wcslen(wcs)}');
  print('wcschr("hello", \'l\') index = ${stdc.wcschr(wcs, 108)}\n');
}

void wctypeEg() {
  print('--- stdc wctype.h examples ---');
  print('iswalpha(\'A\') = ${stdc.iswalpha(65)}');
  print('iswdigit(\'5\') = ${stdc.iswdigit(53)}');
  print('towlower(\'G\') = ${stdc.towlower(71)} (which is \'g\')\n');
}

void stdargEg() {
  print('--- stdc stdarg.h examples ---');
  var ap = stdc.va_start(["Hello Variadic", 42]);
  print('va_arg<String> = ${stdc.va_arg<String>(ap)}');
  print('va_arg<int> = ${stdc.va_arg<int>(ap)}');
  stdc.va_end(ap);
  print('');
}

void signalEg() {
  print('--- stdc signal.h examples ---');
  bool signalCaught = false;

  void customHandler(int sig) {
    print('Caught signal $sig!');
    signalCaught = true;
  }

  print('Registering custom handler for SIGINT...');
  var prev = stdc.signal(stdc.SIGINT, customHandler);
  
  print('Raising SIGINT manually...');
  stdc.raise(stdc.SIGINT);
  
  print('Signal caught? $signalCaught');
  
  print('Restoring default handler...');
  stdc.signal(stdc.SIGINT, prev);
  print('');
}

void main() {
  mathEg();
  ctypeEg();
  stringEg();
  stdlibEg();
  timeEg();
  stdioEg();
  
  // New headers introduced in 1.0.5
  assertEg();
  limitsEg();
  floatEg();
  errnoEg();
  
  // New headers introduced in 1.0.6
  stdintEg();
  stdboolEg();
  stddefEg();
  
  // New headers introduced in 1.0.7
  complexEg();
  inttypesEg();
  ucharEg();
  
  // New headers introduced in 1.0.8
  localeEg();
  wcharEg();
  wctypeEg();

  // New headers introduced in 1.1.0+
  stdargEg();
  signalEg();
}

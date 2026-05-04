import 'package:stdc/math.dart';
import 'package:stdc/ctype.dart';


void main() {
  print('--- stdc math.h examples ---');

  // Using sqrt
  var num = 16.0;
  print('sqrt($num) = ${stdc.sqrt(num)}');

  // Using pow
  var base = 2.0;
  var exp = 8.0;
  print('pow($base, $exp) = ${stdc.pow(base, exp)}');

  // Trigonometry
  var pi = 3.1415926535897932;
  print('sin(pi/2) = ${stdc.sin(pi / 2)}');

  // Absolute values
  print('abs(-42) = ${stdc.abs(-42)}');
  print('fabs(-3.14) = ${stdc.fabs(-3.14)}');

  // Ceil and floor
  print('ceil(2.3) = ${stdc.ceil(2.3)}');
  print('floor(2.8) = ${stdc.floor(2.8)}');
  print('');

  print('--- stdc ctype.h examples ---');
  
  // Character classification
  print('isalpha("A") = ${stdc.isalpha("A")}');
  print('isdigit("5") = ${stdc.isdigit("5")}');
  print('isspace(" ") = ${stdc.isspace(" ")}');
  print('ispunct("!") = ${stdc.ispunct("!")}');

  // Character conversion
  print('toupper("h") = ${stdc.toupper("h")}');
  print('tolower("G") = ${stdc.tolower("G")}');
}


// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:io';

export 'dart:io' show File, RandomAccessFile, FileMode;

void stdioWrite(String str) {
  stdout.write(str);
}

void stdioWriteCharCode(int charCode) {
  stdout.writeCharCode(charCode);
}

int stdioReadByteSync() {
  return stdin.readByteSync();
}

String? stdioReadLineSync() {
  return stdin.readLineSync();
}

void stdioWriteln(String str) {
  stdout.writeln(str);
}

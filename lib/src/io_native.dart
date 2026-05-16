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

String? stdlibGetenv(String name) {
  return Platform.environment[name];
}

int stdlibSystem(String command) {
  return Process.runSync(command, [], runInShell: true).exitCode;
}

void stdlibExit(int code) {
  exit(code);
}

void stdlibAbort() {
  exit(1);
}

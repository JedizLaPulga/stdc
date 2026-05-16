// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'dart:convert';

class FileMode {
  static const read = FileMode._();
  static const write = FileMode._();
  static const append = FileMode._();
  static const writeOnly = FileMode._();
  static const writeOnlyAppend = FileMode._();
  const FileMode._();
}

class RandomAccessFile {
  void closeSync() {}
  void flushSync() {}
  int readByteSync() => throw UnsupportedError('File I/O is not supported on the web platform');
  int readIntoSync(List<int> buffer, [int start = 0, int? end]) => throw UnsupportedError('File I/O is not supported on the web platform');
  void writeByteSync(int value) => throw UnsupportedError('File I/O is not supported on the web platform');
  void writeFromSync(List<int> buffer, [int start = 0, int? end]) => throw UnsupportedError('File I/O is not supported on the web platform');
  void writeStringSync(String string, {Encoding encoding = utf8}) => throw UnsupportedError('File I/O is not supported on the web platform');
  int lengthSync() => throw UnsupportedError('File I/O is not supported on the web platform');
  int positionSync() => throw UnsupportedError('File I/O is not supported on the web platform');
  void setPositionSync(int position) => throw UnsupportedError('File I/O is not supported on the web platform');
}

class File {
  final String path;
  File(this.path);
  RandomAccessFile openSync({FileMode mode = FileMode.read}) => throw UnsupportedError('File I/O is not supported on the web platform');
}

void stdioWrite(String str) {
  print(str); // Fallback for web, prints with a newline
}

void stdioWriteCharCode(int charCode) {
  print(String.fromCharCode(charCode)); // Fallback
}

int stdioReadByteSync() {
  throw UnsupportedError('stdin is not supported on the web platform');
}

String? stdioReadLineSync() {
  throw UnsupportedError('stdin is not supported on the web platform');
}

void stdioWriteln(String str) {
  print(str);
}

String? stdlibGetenv(String name) {
  return null;
}

int stdlibSystem(String command) {
  throw UnsupportedError('Process execution is not supported on the web platform');
}

void stdlibExit(int code) {
  throw UnsupportedError('Process exit is not supported on the web platform');
}

void stdlibAbort() {
  throw UnsupportedError('Process abort is not supported on the web platform');
}

// ignore_for_file: non_constant_identifier_names, camel_case_types

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

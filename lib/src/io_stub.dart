// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'dart:convert';

/// File modes for stub implementation.
class FileMode {
  /// Read mode.
  static const read = FileMode._();
  /// Write mode.
  static const write = FileMode._();
  /// Append mode.
  static const append = FileMode._();
  /// Write-only mode.
  static const writeOnly = FileMode._();
  /// Write-only append mode.
  static const writeOnlyAppend = FileMode._();
  const FileMode._();
}

/// A stub class representing a random access file on platforms where dart:io is unavailable.
class RandomAccessFile {
  /// Closes the file.
  void closeSync() {}
  /// Flushes pending changes to the file.
  void flushSync() {}
  /// Reads a single byte.
  int readByteSync() => throw UnsupportedError('File I/O is not supported on the web platform');
  /// Reads bytes into a buffer.
  int readIntoSync(List<int> buffer, [int start = 0, int? end]) => throw UnsupportedError('File I/O is not supported on the web platform');
  /// Writes a single byte.
  void writeByteSync(int value) => throw UnsupportedError('File I/O is not supported on the web platform');
  /// Writes bytes from a buffer.
  void writeFromSync(List<int> buffer, [int start = 0, int? end]) => throw UnsupportedError('File I/O is not supported on the web platform');
  /// Writes a string to the file.
  void writeStringSync(String string, {Encoding encoding = utf8}) => throw UnsupportedError('File I/O is not supported on the web platform');
  /// Gets the length of the file.
  int lengthSync() => throw UnsupportedError('File I/O is not supported on the web platform');
  /// Gets the current position in the file.
  int positionSync() => throw UnsupportedError('File I/O is not supported on the web platform');
  /// Sets the current position in the file.
  void setPositionSync(int position) => throw UnsupportedError('File I/O is not supported on the web platform');
}

/// A stub class representing a File on platforms where dart:io is unavailable.
class File {
  /// The path of the file.
  final String path;
  /// Creates a new File stub.
  File(this.path);
  /// Opens the file for random access.
  RandomAccessFile openSync({FileMode mode = FileMode.read}) => throw UnsupportedError('File I/O is not supported on the web platform');
}

/// A stub class representing a Directory on platforms where dart:io is unavailable.
class Directory {
  /// The system temporary directory.
  static final Directory systemTemp = Directory._();
  /// The path of the directory.
  final String path = '/tmp';
  Directory._();
}

/// Writes a string to standard output (fallback stub).
void stdioWrite(String str) {
  print(str); // Fallback for web, prints with a newline
}

/// Writes a character code to standard output (fallback stub).
void stdioWriteCharCode(int charCode) {
  print(String.fromCharCode(charCode)); // Fallback
}

/// Reads a single byte synchronously from standard input (fallback stub).
int stdioReadByteSync() {
  throw UnsupportedError('stdin is not supported on the web platform');
}

/// Reads a full line of text synchronously from standard input (fallback stub).
String? stdioReadLineSync() {
  throw UnsupportedError('stdin is not supported on the web platform');
}

/// Writes a string followed by a newline to standard output (fallback stub).
void stdioWriteln(String str) {
  print(str);
}

/// Retrieves the value of an environment variable (fallback stub).
String? stdlibGetenv(String name) {
  return null;
}

/// Executes a shell command synchronously and returns the exit code (fallback stub).
int stdlibSystem(String command) {
  throw UnsupportedError('Process execution is not supported on the web platform');
}

/// Exits the process with the given exit code (fallback stub).
void stdlibExit(int code) {
  throw UnsupportedError('Process exit is not supported on the web platform');
}

/// Aborts the process abnormally (fallback stub).
void stdlibAbort() {
  throw UnsupportedError('Process abort is not supported on the web platform');
}

/// Sets a signal handler for a given signal number (fallback stub).
dynamic stdlibSetSignalHandler(int sig, void Function(int)? handler) {
  // Signals are not supported on the web platform.
  return null; 
}

/// Writes a string to standard error (fallback stub).
void stdioWriteErr(String str) {
  print(str); // Fallback
}

/// Removes a file synchronously (fallback stub).
int ioRemoveSync(String filename) {
  return -1; // Not supported
}

/// Renames a file synchronously (fallback stub).
int ioRenameSync(String oldFilename, String newFilename) {
  return -1; // Not supported
}

/// Generates a valid temporary filename (fallback stub).
String ioTmpnam(List<int>? str) {
  return '/tmp/stdc_tmp_web_unsupported';
}

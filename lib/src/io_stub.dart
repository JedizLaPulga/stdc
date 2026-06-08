// ignore_for_file: non_constant_identifier_names, camel_case_types, public_member_api_docs, constant_identifier_names, strict_top_level_inference
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
  static final Directory systemTemp = Directory._('/tmp');
  /// The path of the directory.
  final String path;
  Directory(this.path);
  Directory._(this.path);

  void createSync({bool recursive = false}) {
    throw UnsupportedError('Directory is not supported on the web platform');
  }

  void deleteSync({bool recursive = false}) {
    throw UnsupportedError('Directory is not supported on the web platform');
  }
}

class FileStat {
  static FileStat statSync(String path) => throw UnsupportedError('FileStat not supported');
  final int mode = 0;
  final int size = 0;
  final DateTime accessed = DateTime.now();
  final DateTime modified = DateTime.now();
  final DateTime changed = DateTime.now();
  final FileSystemEntityType type = FileSystemEntityType.notFound;
}

class FileSystemEntityType {
  static const file = FileSystemEntityType._();
  static const directory = FileSystemEntityType._();
  static const link = FileSystemEntityType._();
  static const notFound = FileSystemEntityType._();
  const FileSystemEntityType._();
}

class Socket {
  static void connect(host, int port) => throw UnsupportedError('Socket not supported');
}

class ServerSocket {
  static void bind(address, int port) => throw UnsupportedError('ServerSocket not supported');
}

class RawDatagramSocket {
  static void bind(address, int port) => throw UnsupportedError('RawDatagramSocket not supported');
}

class InternetAddress {
  static final anyIPv4 = InternetAddress._();
  static final loopbackIPv4 = InternetAddress._();
  const InternetAddress._();
}

class InternetAddressType {
  static const IPv4 = InternetAddressType._();
  static const IPv6 = InternetAddressType._();
  const InternetAddressType._();
}

class SocketException implements Exception {}

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

/// Opens a directory and returns an iterator over its contents (stub).
Iterator<dynamic>? ioOpendir(String name) {
  throw UnsupportedError('Directory iteration is not supported on the web platform');
}

/// Extracts the base name from a native file system entity (stub).
String ioGetDirentName(dynamic entity) {
  throw UnsupportedError('Directory iteration is not supported on the web platform');
}

/// Sleeps for the specified number of seconds synchronously (fallback stub).
int ioSleep(int seconds) {
  throw UnsupportedError('sleep is not supported on the web platform');
}

/// Sleeps for the specified number of microseconds synchronously (fallback stub).
int ioUsleep(int microseconds) {
  throw UnsupportedError('usleep is not supported on the web platform');
}

/// Returns the process ID of the current process (fallback stub).
int ioGetpid() {
  throw UnsupportedError('getpid is not supported on the web platform');
}

/// Retrieves system identification information for uname (stub).
Map<String, String> ioUname() {
  return {
    'sysname': 'web',
    'nodename': 'localhost',
    'release': '1.0',
    'version': '1.0',
    'machine': 'wasm',
  };
}

/// Gets terminal attributes (stub).
int ioTcgetattr() {
  return 3;
}

/// Sets terminal attributes (stub).
int ioTcsetattr(int lflag) {
  return -1;
}

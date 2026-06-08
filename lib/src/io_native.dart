// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:async';
import 'dart:io';

export 'dart:io' show File, RandomAccessFile, FileMode, Directory, FileStat, FileSystemEntityType, Socket, ServerSocket, RawDatagramSocket, InternetAddress, InternetAddressType, SocketException, Process;

/// Sleeps for the specified number of seconds synchronously.
int ioSleep(int seconds) {
  sleep(Duration(seconds: seconds));
  return 0;
}

/// Sleeps for the specified number of microseconds synchronously.
int ioUsleep(int microseconds) {
  sleep(Duration(microseconds: microseconds));
  return 0;
}

/// Returns the process ID of the current process.
int ioGetpid() {
  return pid;
}

/// Writes a string directly to standard output.
void stdioWrite(String str) {
  stdout.write(str);
}

/// Writes a single character code directly to standard output.
void stdioWriteCharCode(int charCode) {
  stdout.writeCharCode(charCode);
}

/// Reads a single byte synchronously from standard input.
int stdioReadByteSync() {
  return stdin.readByteSync();
}

/// Reads a full line of text synchronously from standard input.
String? stdioReadLineSync() {
  return stdin.readLineSync();
}

/// Writes a string followed by a newline directly to standard output.
void stdioWriteln(String str) {
  stdout.writeln(str);
}

/// Retrieves the value of the environment variable [name].
String? stdlibGetenv(String name) {
  return Platform.environment[name];
}

/// Executes a shell command synchronously and returns its exit code.
int stdlibSystem(String command) {
  return Process.runSync(command, [], runInShell: true).exitCode;
}

/// Terminates the current process immediately with the specified exit [code].
void stdlibExit(int code) {
  exit(code);
}

/// Aborts the current process abnormally.
void stdlibAbort() {
  exit(1);
}

/// Registers a handler for a POSIX signal.
StreamSubscription<dynamic>? stdlibSetSignalHandler(int sig, void Function(int)? handler) {
  if (handler == null) return null;
  ProcessSignal? ps;
  switch (sig) {
    case 2: ps = ProcessSignal.sigint; break; // SIGINT
    case 15: ps = ProcessSignal.sigterm; break; // SIGTERM
    // dart:io doesn't expose sigabrt, sigill, sigfpe, sigsegv natively across all OS
  }
  if (ps != null) {
    try {
      return ps.watch().listen((_) => handler(sig));
    } catch (_) {
      // Might not be supported on this platform
      return null;
    }
  }
  return null;
}

/// Writes a string directly to standard error.
void stdioWriteErr(String str) {
  stderr.write(str);
}

/// Removes a file synchronously. Returns 0 on success, -1 on failure.
int ioRemoveSync(String filename) {
  try {
    File(filename).deleteSync();
    return 0;
  } catch (_) {
    return -1;
  }
}

/// Renames a file synchronously. Returns 0 on success, -1 on failure.
int ioRenameSync(String oldFilename, String newFilename) {
  try {
    File(oldFilename).renameSync(newFilename);
    return 0;
  } catch (_) {
    return -1;
  }
}

/// Generates and returns a valid temporary filename.
String ioTmpnam(List<int>? str) {
  final dir = Directory.systemTemp;
  final name = '${dir.path}/stdc_tmp_${DateTime.now().microsecondsSinceEpoch}';
  if (str != null) {
    final bytes = name.codeUnits;
    for (int i = 0; i < bytes.length && i < str.length - 1; i++) {
      str[i] = bytes[i];
    }
    str[bytes.length < str.length ? bytes.length : str.length - 1] = 0;
  }
  return name;
}

/// Opens a directory and returns an iterator over its contents.
Iterator<dynamic>? ioOpendir(String name) {
  try {
    final dir = Directory(name);
    if (!dir.existsSync()) return null;
    return dir.listSync().iterator;
  } catch (_) {
    return null;
  }
}

/// Extracts the base name from a native file system entity.
String ioGetDirentName(dynamic entity) {
  if (entity is FileSystemEntity) {
    final path = entity.path;
    final sep = Platform.pathSeparator;
    final lastSlash = path.lastIndexOf(sep);
    return lastSlash != -1 ? path.substring(lastSlash + 1) : path;
  }
  return '';
}

/// Retrieves system identification information for uname.
Map<String, String> ioUname() {
  return {
    'sysname': Platform.operatingSystem,
    'nodename': Platform.localHostname,
    'release': Platform.operatingSystemVersion,
    'version': Platform.version,
    'machine': 'dart_vm',
  };
}

/// Gets terminal attributes (mocked as returning 1 if echoMode and lineMode are true).
int ioTcgetattr() {
  try {
    return (stdin.echoMode ? 1 : 0) | (stdin.lineMode ? 2 : 0);
  } catch (_) {
    return 3;
  }
}

/// Sets terminal attributes (mocked with echoMode and lineMode).
int ioTcsetattr(int lflag) {
  try {
    stdin.echoMode = (lflag & 1) != 0;
    stdin.lineMode = (lflag & 2) != 0;
    return 0;
  } catch (_) {
    return -1;
  }
}

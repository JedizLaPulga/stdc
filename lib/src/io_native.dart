// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:async';
import 'dart:io';

export 'dart:io' show File, RandomAccessFile, FileMode, Directory;

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

void stdioWriteErr(String str) {
  stderr.write(str);
}

int ioRemoveSync(String filename) {
  try {
    File(filename).deleteSync();
    return 0;
  } catch (_) {
    return -1;
  }
}

int ioRenameSync(String oldFilename, String newFilename) {
  try {
    File(oldFilename).renameSync(newFilename);
    return 0;
  } catch (_) {
    return -1;
  }
}

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

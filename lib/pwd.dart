// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'src/stdc_base.dart';
import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart';

/// Password structure containing user information.
class passwd {
  /// User's login name
  String pw_name = '';
  /// The encrypted password (often "x")
  String pw_passwd = 'x';
  /// Numerical user ID
  int pw_uid = 0;
  /// Numerical group ID
  int pw_gid = 0;
  /// User's real name (GECOS field)
  String pw_gecos = '';
  /// Initial working directory (home directory)
  String pw_dir = '';
  /// Program to use as shell
  String pw_shell = '';
}

/// Extension providing `<pwd.h>` functionality.
extension StdcPwd on Stdc {
  /// Search the user database for a name.
  /// Note: This is a structural mock mapped to current process environment.
  passwd? getpwnam(String name) {
    try {
      final user = stdlibGetenv('USER') ?? stdlibGetenv('USERNAME') ?? 'user';
      if (name != user && name != 'root') return null;
      
      final pw = passwd();
      pw.pw_name = name;
      pw.pw_uid = name == 'root' ? 0 : 1000;
      pw.pw_gid = name == 'root' ? 0 : 1000;
      pw.pw_dir = name == 'root' ? '/root' : (stdlibGetenv('HOME') ?? stdlibGetenv('USERPROFILE') ?? '/home/$name');
      pw.pw_shell = stdlibGetenv('SHELL') ?? '/bin/sh';
      return pw;
    } catch (_) {
      return null;
    }
  }

  /// Search the user database for a user ID.
  /// Note: This is a structural mock mapped to current process environment.
  passwd? getpwuid(int uid) {
    if (uid == 0) return getpwnam('root');
    if (uid == 1000) {
      return getpwnam(stdlibGetenv('USER') ?? stdlibGetenv('USERNAME') ?? 'user');
    }
    return null;
  }
}

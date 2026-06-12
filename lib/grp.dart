// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'src/stdc_base.dart';
import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart';

/// Group structure containing group information.
class group {
  /// The name of the group
  String gr_name = '';
  /// The encrypted group password
  String gr_passwd = 'x';
  /// The numerical group ID
  int gr_gid = 0;
  /// Pointer to a null-terminated array of character pointers to member names.
  List<String> gr_mem = [];
}

/// Extension providing `<grp.h>` functionality.
extension StdcGrp on Stdc {
  /// Search the group database for a name.
  /// Note: This is a structural mock mapped to current process environment.
  group? getgrnam(String name) {
    try {
      if (name == 'root') {
        final gr = group();
        gr.gr_name = 'root';
        gr.gr_gid = 0;
        gr.gr_mem = ['root'];
        return gr;
      }
      
      final user = stdlibGetenv('USER') ?? stdlibGetenv('USERNAME') ?? 'user';
      if (name == user || name == 'users') {
        final gr = group();
        gr.gr_name = name;
        gr.gr_gid = 1000;
        gr.gr_mem = [user];
        return gr;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Search the group database for a group ID.
  /// Note: This is a structural mock mapped to current process environment.
  group? getgrgid(int gid) {
    if (gid == 0) return getgrnam('root');
    if (gid == 1000) return getgrnam('users');
    return null;
  }
}

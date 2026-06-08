// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
import 'src/stdc_base.dart';

/// POSIX Process Wait implementation
extension SysWaitStdc on Stdc {
  /// Wait for process to change state.
  /// Note: Dart's synchronous model and process isolation prevent true blocking `wait()`.
  /// This provides structural API completeness.
  int wait(List<int>? stat_loc) {
    if (stat_loc != null && stat_loc.isNotEmpty) {
      stat_loc[0] = 0;
    }
    return -1; // -1 represents an error (no children to wait for in Dart isolate)
  }

  /// Wait for a specific process to change state.
  int waitpid(int pid, List<int>? stat_loc, int options) {
    if (stat_loc != null && stat_loc.isNotEmpty) {
      stat_loc[0] = 0;
    }
    return -1;
  }
}

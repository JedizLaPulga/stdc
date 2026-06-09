// ignore_for_file: non_constant_identifier_names

/// `<sys/time.h>` implementation for stdc
/// 
/// Contains standard time functions like `gettimeofday` and `timeval` structure.
library;

import 'src/stdc_base.dart';

/// Represents the C standard `struct timeval` containing seconds and microseconds.
class TimeVal {
  /// Seconds
  int tv_sec;
  /// Microseconds
  int tv_usec;

  /// Creates a new [TimeVal] structure.
  TimeVal({
    this.tv_sec = 0,
    this.tv_usec = 0,
  });
}

/// Represents the C standard `struct timezone` containing timezone information.
/// Note: The use of the timezone structure is obsolete; the tz argument should normally be specified as NULL.
class TimeZone {
  /// Minutes west of Greenwich
  int tz_minuteswest;
  /// Type of DST correction
  int tz_dsttime;

  /// Creates a new [TimeZone] structure.
  TimeZone({
    this.tz_minuteswest = 0,
    this.tz_dsttime = 0,
  });
}

/// `<sys/time.h>` standard extensions for `stdc`.
extension SysTimeStdc on Stdc {
  /// The `gettimeofday()` function obtains the current time, expressed as seconds and microseconds since the Epoch,
  /// and stores it in the `TimeVal` structure pointed to by `tv`.
  /// 
  /// The `tz` argument is often null (or omitted) in modern C, but provided here for completeness.
  /// Returns 0 on success, or -1 on failure.
  int gettimeofday(TimeVal tv, [TimeZone? tz]) {
    final now = DateTime.now();
    final microsecondsSinceEpoch = now.microsecondsSinceEpoch;
    
    tv.tv_sec = microsecondsSinceEpoch ~/ 1000000;
    tv.tv_usec = microsecondsSinceEpoch % 1000000;

    if (tz != null) {
      tz.tz_minuteswest = -now.timeZoneOffset.inMinutes;
      tz.tz_dsttime = 0; // Dart doesn't natively expose DST type directly without heavy computation, 0 is safe obsolete default.
    }

    return 0; // Success
  }
}

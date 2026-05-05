/// `<time.h>` implementation for stdc
/// 
/// Contains standard time functions for the `stdc` library.
library;

import 'src/stdc_base.dart';

// Internal global stopwatch to simulate clock()
final Stopwatch _clock = Stopwatch()..start();

/// `<time.h>` standard time extensions for `stdc`.
extension StdcTime on Stdc {
  /// Returns the current calendar time as a Unix timestamp (seconds since epoch).
  int time() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  /// Returns the processor time used by the program since it started.
  /// The returned value is expressed in clock ticks (milliseconds here).
  int clock() {
    return _clock.elapsedMilliseconds;
  }

  /// Returns the difference in seconds between two `time_t` values.
  double difftime(int time1, int time0) {
    return (time1 - time0).toDouble();
  }

  /// Converts a `time_t` value to a string in the format "Www Mmm dd hh:mm:ss yyyy\n".
  /// Note: A simplified approximation for Dart.
  String ctime(int timeValue) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timeValue * 1000);
    return dt.toString(); // basic fallback
  }
}

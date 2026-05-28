// ignore_for_file: non_constant_identifier_names

/// `<time.h>` implementation for stdc
/// 
/// Contains standard time functions for the `stdc` library.
library;

import 'src/stdc_base.dart';

// Internal global stopwatch to simulate clock()
final Stopwatch _clock = Stopwatch()..start();

/// Represents the C standard `struct tm` containing broken-down time.
class Tm {
  /// Seconds after the minute [0, 60]
  int tm_sec;
  /// Minutes after the hour [0, 59]
  int tm_min;
  /// Hours since midnight [0, 23]
  int tm_hour;
  /// Day of the month [1, 31]
  int tm_mday;
  /// Months since January [0, 11]
  int tm_mon;
  /// Years since 1900
  int tm_year;
  /// Days since Sunday [0, 6]
  int tm_wday;
  /// Days since January 1 [0, 365]
  int tm_yday;
  /// Daylight Saving Time flag (-1, 0, or 1)
  int tm_isdst;

  /// Creates a new [Tm] structure.
  Tm({
    this.tm_sec = 0,
    this.tm_min = 0,
    this.tm_hour = 0,
    this.tm_mday = 1,
    this.tm_mon = 0,
    this.tm_year = 0,
    this.tm_wday = 0,
    this.tm_yday = 0,
    this.tm_isdst = -1,
  });

  /// Converts this [Tm] back into a Dart [DateTime].
  DateTime toDateTime({bool isUtc = false}) {
    if (isUtc) {
      return DateTime.utc(tm_year + 1900, tm_mon + 1, tm_mday, tm_hour, tm_min, tm_sec);
    } else {
      return DateTime(tm_year + 1900, tm_mon + 1, tm_mday, tm_hour, tm_min, tm_sec);
    }
  }

  /// Creates a [Tm] from a Dart [DateTime].
  static Tm fromDateTime(DateTime dt) {
    // calculate day of year
    final startOfYear = DateTime(dt.year, 1, 1);
    final daysSinceJan1 = dt.difference(startOfYear).inDays;
    return Tm(
      tm_sec: dt.second,
      tm_min: dt.minute,
      tm_hour: dt.hour,
      tm_mday: dt.day,
      tm_mon: dt.month - 1,
      tm_year: dt.year - 1900,
      tm_wday: dt.weekday == 7 ? 0 : dt.weekday,
      tm_yday: daysSinceJan1,
      tm_isdst: -1, 
    );
  }
}

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
  String ctime(int timeValue) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timeValue * 1000);
    final tm = Tm.fromDateTime(dt);
    return asctime(tm);
  }

  /// Converts a [Tm] structure to a string in the format "Www Mmm dd hh:mm:ss yyyy\n".
  String asctime(Tm timeptr) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final wday = (timeptr.tm_wday >= 0 && timeptr.tm_wday <= 6) ? days[timeptr.tm_wday] : '???';
    final mon = (timeptr.tm_mon >= 0 && timeptr.tm_mon <= 11) ? months[timeptr.tm_mon] : '???';
    
    final dayStr = timeptr.tm_mday.toString().padLeft(2, ' ');
    final hourStr = timeptr.tm_hour.toString().padLeft(2, '0');
    final minStr = timeptr.tm_min.toString().padLeft(2, '0');
    final secStr = timeptr.tm_sec.toString().padLeft(2, '0');
    final year = timeptr.tm_year + 1900;

    return '$wday $mon $dayStr $hourStr:$minStr:$secStr $year\n';
  }

  /// Converts a Unix timestamp (`time_t`) to a local [Tm] structure.
  Tm localtime(int timeValue) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timeValue * 1000, isUtc: false);
    return Tm.fromDateTime(dt);
  }

  /// Converts a Unix timestamp (`time_t`) to a UTC [Tm] structure.
  Tm gmtime(int timeValue) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timeValue * 1000, isUtc: true);
    return Tm.fromDateTime(dt);
  }

  /// Converts a local [Tm] structure to a Unix timestamp (`time_t`).
  /// This also normalizes the values in [timeptr].
  int mktime(Tm timeptr) {
    final dt = timeptr.toDateTime(isUtc: false);
    final normalized = Tm.fromDateTime(dt);
    timeptr.tm_sec = normalized.tm_sec;
    timeptr.tm_min = normalized.tm_min;
    timeptr.tm_hour = normalized.tm_hour;
    timeptr.tm_mday = normalized.tm_mday;
    timeptr.tm_mon = normalized.tm_mon;
    timeptr.tm_year = normalized.tm_year;
    timeptr.tm_wday = normalized.tm_wday;
    timeptr.tm_yday = normalized.tm_yday;
    timeptr.tm_isdst = normalized.tm_isdst;
    return dt.millisecondsSinceEpoch ~/ 1000;
  }

  /// Formats time according to the [format] string and [timeptr] structure.
  /// 
  /// Returns the formatted [String].
  /// Supported specifiers: `%a`, `%A`, `%b`, `%B`, `%c`, `%d`, `%H`, `%I`, `%j`, 
  /// `%m`, `%M`, `%p`, `%S`, `%U`, `%w`, `%W`, `%x`, `%X`, `%y`, `%Y`, `%%`.
  String strftime(String format, Tm timeptr) {
    const shortDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const longDays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const shortMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const longMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    final buffer = StringBuffer();
    int i = 0;
    while (i < format.length) {
      if (format[i] == '%' && i + 1 < format.length) {
        final specifier = format[i + 1];
        switch (specifier) {
          case 'a':
            buffer.write((timeptr.tm_wday >= 0 && timeptr.tm_wday <= 6) ? shortDays[timeptr.tm_wday] : '');
            break;
          case 'A':
            buffer.write((timeptr.tm_wday >= 0 && timeptr.tm_wday <= 6) ? longDays[timeptr.tm_wday] : '');
            break;
          case 'b':
          case 'h':
            buffer.write((timeptr.tm_mon >= 0 && timeptr.tm_mon <= 11) ? shortMonths[timeptr.tm_mon] : '');
            break;
          case 'B':
            buffer.write((timeptr.tm_mon >= 0 && timeptr.tm_mon <= 11) ? longMonths[timeptr.tm_mon] : '');
            break;
          case 'c':
            buffer.write(asctime(timeptr).replaceAll('\n', ''));
            break;
          case 'd':
            buffer.write(timeptr.tm_mday.toString().padLeft(2, '0'));
            break;
          case 'H':
            buffer.write(timeptr.tm_hour.toString().padLeft(2, '0'));
            break;
          case 'I':
            int hour12 = timeptr.tm_hour % 12;
            if (hour12 == 0) hour12 = 12;
            buffer.write(hour12.toString().padLeft(2, '0'));
            break;
          case 'j':
            buffer.write((timeptr.tm_yday + 1).toString().padLeft(3, '0'));
            break;
          case 'm':
            buffer.write((timeptr.tm_mon + 1).toString().padLeft(2, '0'));
            break;
          case 'M':
            buffer.write(timeptr.tm_min.toString().padLeft(2, '0'));
            break;
          case 'p':
            buffer.write(timeptr.tm_hour < 12 ? 'AM' : 'PM');
            break;
          case 'S':
            buffer.write(timeptr.tm_sec.toString().padLeft(2, '0'));
            break;
          case 'U': 
          case 'W': 
            buffer.write((timeptr.tm_yday ~/ 7).toString().padLeft(2, '0'));
            break;
          case 'w':
            buffer.write(timeptr.tm_wday.toString());
            break;
          case 'x':
            buffer.write('${(timeptr.tm_mon + 1).toString().padLeft(2, '0')}/${timeptr.tm_mday.toString().padLeft(2, '0')}/${(timeptr.tm_year % 100).toString().padLeft(2, '0')}');
            break;
          case 'X':
            buffer.write('${timeptr.tm_hour.toString().padLeft(2, '0')}:${timeptr.tm_min.toString().padLeft(2, '0')}:${timeptr.tm_sec.toString().padLeft(2, '0')}');
            break;
          case 'y':
            buffer.write((timeptr.tm_year % 100).toString().padLeft(2, '0'));
            break;
          case 'Y':
            buffer.write((timeptr.tm_year + 1900).toString().padLeft(4, '0'));
            break;
          case '%':
            buffer.write('%');
            break;
          default:
            buffer.write('%$specifier');
            break;
        }
        i += 2;
      } else {
        buffer.write(format[i]);
        i++;
      }
    }
    return buffer.toString();
  }
}

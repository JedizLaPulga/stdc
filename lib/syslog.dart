// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'dart:developer' as dev;
import 'src/stdc_base.dart';

/// Extension providing `<syslog.h>` functionality.
extension StdcSyslog on Stdc {
  // Priorities
  /// system is unusable
  int get LOG_EMERG => 0;   
  /// action must be taken immediately
  int get LOG_ALERT => 1;   
  /// critical conditions
  int get LOG_CRIT => 2;    
  /// error conditions
  int get LOG_ERR => 3;     
  /// warning conditions
  int get LOG_WARNING => 4; 
  /// normal but significant condition
  int get LOG_NOTICE => 5;  
  /// informational
  int get LOG_INFO => 6;    
  /// debug-level messages
  int get LOG_DEBUG => 7;   
  // Options
  /// log the pid with each message
  int get LOG_PID => 0x01;    
  /// log on the console if errors in sending
  int get LOG_CONS => 0x02;   
  /// delay open until first syslog() (default)
  int get LOG_ODELAY => 0x04; 
  /// don't delay open
  int get LOG_NDELAY => 0x08; 
  /// don't wait for console forks: DEPRECATED
  int get LOG_NOWAIT => 0x10; 
  /// log to stderr as well
  int get LOG_PERROR => 0x20; 

  // Facilities
  /// random user-level messages
  int get LOG_USER => 1 << 3; 

  static String? _ident;

  static int _mask = 0xFF; // All allowed by default

  /// Opens a connection to the system logger for a program.
  void openlog(String ident, int logopt, int facility) {
    _ident = ident;
  }

  /// Generates a log message.
  void syslog(int priority, String message) {
    if ((_mask & LOG_MASK(priority)) == 0) return;
    
    String prefix = _ident != null ? '$_ident: ' : '';
    
    // In Dart, we map syslog to dart:developer log and standard print
    dev.log(message, name: _ident ?? 'syslog', level: priority * 100);
    
    // Simulate LOG_PERROR or standard console output
    print('<$priority> $prefix$message');
  }

  /// Closes the file descriptor being used to write to the system logger.
  void closelog() {
    _ident = null;
  }

  /// Sets the logmask and returns the previous mask.
  int setlogmask(int maskpri) {
    int old = _mask;
    if (maskpri != 0) {
      _mask = maskpri;
    }
    return old;
  }

  /// Creates a mask for a single priority.
  int LOG_MASK(int pri) => 1 << pri;

  /// Creates a mask for all priorities up to and including [pri].
  int LOG_UPTO(int pri) => (1 << (pri + 1)) - 1;
}

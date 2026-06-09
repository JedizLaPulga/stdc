// ignore_for_file: non_constant_identifier_names, constant_identifier_names

/// `<getopt.h>` implementation for stdc
/// 
/// Contains command line argument parsing utilities.
library;

import 'src/io_stub.dart' if (dart.library.io) 'src/io_native.dart';
import 'src/stdc_base.dart';


/// Indicates that the option takes no argument.
const int no_argument = 0;

/// Indicates that the option requires an argument.
const int required_argument = 1;

/// Indicates that the option takes an optional argument.
const int optional_argument = 2;

/// Structure for long options used by `getopt_long`.
class Option {
  /// The name of the long option.
  final String name;
  /// One of `no_argument`, `required_argument`, or `optional_argument`.
  final int has_arg;
  /// If not null, specifies a list of 1 element where the value of `val` is stored.
  /// If null, `getopt_long` returns `val`.
  final List<int>? flag;
  /// The value to return, or to load into the `flag` if it's not null.
  final int val;

  /// Creates a new [Option] structure.
  const Option(this.name, this.has_arg, this.flag, this.val);
}

/// `<getopt.h>` standard and GNU extensions for `stdc`.
extension GetoptStdc on Stdc {
  static String? _optarg;
  static int _optind = 1;
  static int _opterr = 1;
  static int _optopt = 0;
  static int _optpos = 1; // Internal index within a grouped short option string

  /// For communication from `getopt` to the caller.
  /// When `getopt` finds an option that takes an argument, the argument value is stored here.
  String? get optarg => _optarg;
  set optarg(String? value) => _optarg = value;

  /// Index of the next element to be processed in argv.
  /// The system initializes this value to 1.
  int get optind => _optind;
  set optind(int value) {
    _optind = value;
    _optpos = 1; // Reset internal pos on manual change
  }

  /// If `opterr` is set to 0, `getopt` does not print an error message.
  int get opterr => _opterr;
  set opterr(int value) => _opterr = value;

  /// When `getopt` encounters an unknown option character or an option with a missing required argument,
  /// it stores that option character in this variable.
  int get optopt => _optopt;
  set optopt(int value) => _optopt = value;

  /// Resets the internal `getopt` state.
  void optreset() {
    _optind = 1;
    _opterr = 1;
    _optopt = 0;
    _optpos = 1;
    _optarg = null;
  }

  void _printError(String argv0, String message) {
    if (_opterr != 0) {
      stdioWriteErr("$argv0: $message\n");
    }
  }

  /// Parses command-line arguments.
  int getopt(int argc, List<String> argv, String optstring) {
    _optarg = null;

    if (_optind >= argc || _optind < 0) {
      return -1;
    }

    String arg = argv[_optind];

    if (arg.isEmpty || arg[0] != '-' || arg == '-') {
      return -1;
    }

    if (arg == '--') {
      _optind++;
      return -1;
    }

    if (_optpos >= arg.length) {
      _optpos = 1;
      return -1; // Should not happen if correctly formed, but just in case
    }

    String optchar = arg[_optpos];
    int optcharCode = optchar.codeUnitAt(0);
    int idx = optstring.indexOf(optchar);

    if (idx == -1) {
      _optopt = optcharCode;
      _printError(argv[0], "invalid option -- '$optchar'");
      if (_optpos + 1 < arg.length) {
        _optpos++;
      } else {
        _optind++;
        _optpos = 1;
      }
      return '?'.codeUnitAt(0);
    }

    bool hasArg = idx + 1 < optstring.length && optstring[idx + 1] == ':';
    bool optionalArg = hasArg && idx + 2 < optstring.length && optstring[idx + 2] == ':';

    if (hasArg) {
      if (_optpos + 1 < arg.length) {
        // Argument is attached, like -fFile
        _optarg = arg.substring(_optpos + 1);
        _optind++;
        _optpos = 1;
      } else if (_optind + 1 < argc) {
        // Argument is the next argv element
        _optarg = argv[_optind + 1];
        _optind += 2;
        _optpos = 1;
      } else {
        // Missing required argument
        if (optionalArg) {
          _optarg = null;
          _optind++;
          _optpos = 1;
        } else {
          _optopt = optcharCode;
          if (optstring.startsWith(':')) {
            return ':'.codeUnitAt(0);
          } else {
            _printError(argv[0], "option requires an argument -- '$optchar'");
            return '?'.codeUnitAt(0);
          }
        }
      }
    } else {
      if (_optpos + 1 < arg.length) {
        _optpos++;
      } else {
        _optind++;
        _optpos = 1;
      }
    }

    return optcharCode;
  }

  /// Parses long options in addition to short options.
  int getopt_long(int argc, List<String> argv, String optstring, List<Option> longopts, [List<int>? longindex]) {
    _optarg = null;

    if (_optind >= argc || _optind < 0) {
      return -1;
    }

    String arg = argv[_optind];

    if (arg.isEmpty || arg[0] != '-' || arg == '-') {
      return -1;
    }

    if (arg == '--') {
      _optind++;
      return -1;
    }

    // Handle long options
    if (arg.startsWith('--')) {
      String opt = arg.substring(2);
      String? eqArg;
      int eqIdx = opt.indexOf('=');
      if (eqIdx != -1) {
        eqArg = opt.substring(eqIdx + 1);
        opt = opt.substring(0, eqIdx);
      }

      int matchIdx = -1;
      bool ambiguous = false;

      for (int i = 0; i < longopts.length; i++) {
        if (longopts[i].name == opt) {
          matchIdx = i;
          ambiguous = false;
          break;
        } else if (longopts[i].name.startsWith(opt)) {
          if (matchIdx == -1) {
            matchIdx = i;
          } else {
            ambiguous = true;
          }
        }
      }

      if (ambiguous) {
        _printError(argv[0], "option '--$opt' is ambiguous");
        _optind++;
        return '?'.codeUnitAt(0);
      }

      if (matchIdx != -1) {
        if (longindex != null && longindex.isNotEmpty) {
          longindex[0] = matchIdx;
        }

        var option = longopts[matchIdx];

        if (option.has_arg == required_argument) {
          if (eqArg != null) {
            _optarg = eqArg;
            _optind++;
          } else if (_optind + 1 < argc) {
            _optarg = argv[_optind + 1];
            _optind += 2;
          } else {
            _printError(argv[0], "option '--${option.name}' requires an argument");
            _optind++;
            return optstring.startsWith(':') ? ':'.codeUnitAt(0) : '?'.codeUnitAt(0);
          }
        } else if (option.has_arg == optional_argument) {
          if (eqArg != null) {
            _optarg = eqArg;
          } else {
            _optarg = null;
          }
          _optind++;
        } else {
          // no_argument
          if (eqArg != null) {
            _printError(argv[0], "option '--${option.name}' doesn't allow an argument");
            _optind++;
            return '?'.codeUnitAt(0);
          }
          _optind++;
        }

        if (option.flag != null && option.flag!.isNotEmpty) {
          option.flag![0] = option.val;
          return 0;
        }
        return option.val;
      }

      // If we are here, long option not found
      _printError(argv[0], "unrecognized option '--$opt'");
      _optind++;
      return '?'.codeUnitAt(0);
    }

    // Fall back to short options
    return getopt(argc, argv, optstring);
  }
}

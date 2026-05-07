// ignore_for_file: camel_case_types, non_constant_identifier_names
/// `<errno.h>` implementation for stdc
/// 
/// Contains global error state tracking mimicking standard C.
library;

import 'src/stdc_base.dart';

// Isolate-global state for errno
int _errno = 0;

/// Extension on [Stdc] to provide `<errno.h>` functionality.
extension StdcErrno on Stdc {
  /// Getter for the global `errno` value.
  int get errno => _errno;

  /// Setter for the global `errno` value.
  set errno(int value) {
    _errno = value;
  }

  // --- Standard C Error Macros ---

  /// Argument list too long
  int get E2BIG => 7;
  /// Permission denied
  int get EACCES => 13;
  /// Address in use
  int get EADDRINUSE => 98;
  /// Address not available
  int get EADDRNOTAVAIL => 99;
  /// Address family not supported
  int get EAFNOSUPPORT => 97;
  /// Resource unavailable, try again
  int get EAGAIN => 11;
  /// Connection already in progress
  int get EALREADY => 114;
  /// Bad file descriptor
  int get EBADF => 9;
  /// Bad message
  int get EBADMSG => 74;
  /// Device or resource busy
  int get EBUSY => 16;
  /// Operation canceled
  int get ECANCELED => 125;
  /// No child processes
  int get ECHILD => 10;
  /// Connection aborted
  int get ECONNABORTED => 103;
  /// Connection refused
  int get ECONNREFUSED => 111;
  /// Connection reset
  int get ECONNRESET => 104;
  /// Resource deadlock would occur
  int get EDEADLK => 35;
  /// Destination address required
  int get EDESTADDRREQ => 89;
  /// Mathematics argument out of domain of function
  int get EDOM => 33;
  /// File exists
  int get EEXIST => 17;
  /// Bad address
  int get EFAULT => 14;
  /// File too large
  int get EFBIG => 27;
  /// Host is unreachable
  int get EHOSTUNREACH => 113;
  /// Identifier removed
  int get EIDRM => 43;
  /// Illegal byte sequence
  int get EILSEQ => 84;
  /// Operation in progress
  int get EINPROGRESS => 115;
  /// Interrupted function
  int get EINTR => 4;
  /// Invalid argument
  int get EINVAL => 22;
  /// I/O error
  int get EIO => 5;
  /// Socket is connected
  int get EISCONN => 106;
  /// Is a directory
  int get EISDIR => 21;
  /// Too many levels of symbolic links
  int get ELOOP => 40;
  /// File descriptor value too large
  int get EMFILE => 24;
  /// Too many links
  int get EMLINK => 31;
  /// Message too large
  int get EMSGSIZE => 90;
  /// Reserved
  int get ENAMETOOLONG => 36;
  /// Network is down
  int get ENETDOWN => 100;
  /// Connection aborted by network
  int get ENETRESET => 102;
  /// Network unreachable
  int get ENETUNREACH => 101;
  /// Too many files open in system
  int get ENFILE => 23;
  /// No buffer space available
  int get ENOBUFS => 105;
  /// No message is available on the STREAM head read queue
  int get ENODATA => 61;
  /// No such device
  int get ENODEV => 19;
  /// No such file or directory
  int get ENOENT => 2;
  /// Exec format error
  int get ENOEXEC => 8;
  /// No locks available
  int get ENOLCK => 37;
  /// Link has been severed
  int get ENOLINK => 67;
  /// Not enough space
  int get ENOMEM => 12;
  /// No message of the desired type
  int get ENOMSG => 42;
  /// Protocol not available
  int get ENOPROTOOPT => 92;
  /// No space left on device
  int get ENOSPC => 28;
  /// No STREAM resources
  int get ENOSR => 63;
  /// Not a STREAM
  int get ENOSTR => 60;
  /// Function not supported
  int get ENOSYS => 38;
  /// The socket is not connected
  int get ENOTCONN => 107;
  /// Not a directory
  int get ENOTDIR => 20;
  /// Directory not empty
  int get ENOTEMPTY => 39;
  /// State not recoverable
  int get ENOTRECOVERABLE => 131;
  /// Not a socket
  int get ENOTSOCK => 88;
  /// Not supported
  int get ENOTSUP => 95;
  /// Inappropriate I/O control operation
  int get ENOTTY => 25;
  /// No such device or address
  int get ENXIO => 6;
  /// Operation not supported on socket
  int get EOPNOTSUPP => 95;
  /// Value too large to be stored in data type
  int get EOVERFLOW => 75;
  /// Previous owner died
  int get EOWNERDEAD => 130;
  /// Operation not permitted
  int get EPERM => 1;
  /// Broken pipe
  int get EPIPE => 32;
  /// Protocol error
  int get EPROTO => 71;
  /// Protocol not supported
  int get EPROTONOSUPPORT => 93;
  /// Protocol wrong type for socket
  int get EPROTOTYPE => 91;
  /// Result too large
  int get ERANGE => 34;
  /// Read-only file system
  int get EROFS => 30;
  /// Invalid seek
  int get ESPIPE => 29;
  /// No such process
  int get ESRCH => 3;
  /// Stream ioctl() timeout
  int get ETIME => 62;
  /// Connection timed out
  int get ETIMEDOUT => 110;
  /// Text file busy
  int get ETXTBSY => 26;
  /// Operation would block
  int get EWOULDBLOCK => 11;
  /// Cross-device link
  int get EXDEV => 18;
}

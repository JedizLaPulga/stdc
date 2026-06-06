// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
import 'src/stdc_base.dart';

/// POSIX Socket definitions
extension SysSocketStdc on Stdc {
  /// Unix domain
  int get AF_UNIX => 1;
  /// IPv4 domain
  int get AF_INET => 2;
  /// IPv6 domain
  int get AF_INET6 => 3;

  /// Stream socket
  int get SOCK_STREAM => 1;
  /// Datagram socket
  int get SOCK_DGRAM => 2;
  /// Raw socket
  int get SOCK_RAW => 3;

  /// Socket level option
  int get SOL_SOCKET => 1;
  /// Reuse address option
  int get SO_REUSEADDR => 2;

  /// Create a socket
  int socket(int domain, int type, int protocol) {
    return -1; // Stubbed for Dart synchronous limitations
  }

  /// Bind a socket
  int bind(int sockfd, dynamic addr, int addrlen) {
    return -1; // Stubbed
  }

  /// Listen on a socket
  int listen(int sockfd, int backlog) {
    return -1; // Stubbed
  }

  /// Accept a connection
  int accept(int sockfd, dynamic addr, dynamic addrlen) {
    return -1; // Stubbed
  }

  /// Connect to a socket
  int connect(int sockfd, dynamic addr, int addrlen) {
    return -1; // Stubbed
  }

  /// Send data over a socket
  int send(int sockfd, List<int> buf, int len, int flags) {
    return -1; // Stubbed
  }

  /// Receive data from a socket
  int recv(int sockfd, List<int> buf, int len, int flags) {
    return -1; // Stubbed
  }
}

/// Socket address structure
class sockaddr {
  /// Address family
  int sa_family = 0;
  /// Address data
  List<int> sa_data = List.filled(14, 0);
}

/// Socket address storage
class sockaddr_storage {
  /// Address family
  int ss_family = 0;
}

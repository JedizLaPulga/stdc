import 'src/stdc_base.dart';

/// POSIX Socket definitions
extension SysSocketStdc on Stdc {
  int get AF_UNIX => 1;
  int get AF_INET => 2;
  int get AF_INET6 => 3;

  int get SOCK_STREAM => 1;
  int get SOCK_DGRAM => 2;
  int get SOCK_RAW => 3;

  int get SOL_SOCKET => 1;
  int get SO_REUSEADDR => 2;

  // We provide the API signatures. Since Dart dart:io doesn't fully support 
  // blocking C-style synchronous stream sockets without async, these serve 
  // as the structural definitions for C-ports.
  
  int socket(int domain, int type, int protocol) {
    return -1; // Stubbed for Dart synchronous limitations
  }

  int bind(int sockfd, dynamic addr, int addrlen) {
    return -1; // Stubbed
  }

  int listen(int sockfd, int backlog) {
    return -1; // Stubbed
  }

  int accept(int sockfd, dynamic addr, dynamic addrlen) {
    return -1; // Stubbed
  }

  int connect(int sockfd, dynamic addr, int addrlen) {
    return -1; // Stubbed
  }

  int send(int sockfd, List<int> buf, int len, int flags) {
    return -1; // Stubbed
  }

  int recv(int sockfd, List<int> buf, int len, int flags) {
    return -1; // Stubbed
  }
}

class sockaddr {
  int sa_family = 0;
  List<int> sa_data = List.filled(14, 0);
}

class sockaddr_storage {
  int ss_family = 0;
  // Padding
}

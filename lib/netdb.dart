import 'src/stdc_base.dart';

class addrinfo {
  int ai_flags = 0;
  int ai_family = 0;
  int ai_socktype = 0;
  int ai_protocol = 0;
  int ai_addrlen = 0;
  dynamic ai_addr;
  String? ai_canonname;
  addrinfo? ai_next;
}

extension NetdbStdc on Stdc {
  int getaddrinfo(String? node, String? service, addrinfo? hints, List<addrinfo?> res) {
    // Structural stub
    return -1;
  }

  void freeaddrinfo(addrinfo? res) {
    // No-op in Dart, garbage collection handles this
  }

  String gai_strerror(int errcode) {
    return 'getaddrinfo error';
  }
}

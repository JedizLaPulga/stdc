// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
import 'src/stdc_base.dart';

/// Internet address structure
class in_addr {
  /// Address
  int s_addr = 0;
}

/// Socket address for internet
class sockaddr_in {
  /// Family
  int sin_family = 0;
  /// Port
  int sin_port = 0;
  /// Internet address
  in_addr sin_addr = in_addr();
  /// Zero padding
  List<int> sin_zero = List.filled(8, 0);
}

/// Internet address operations
extension NetinetInStdc on Stdc {
  /// Any address
  int get INADDR_ANY => 0x00000000;
  /// Broadcast address
  int get INADDR_BROADCAST => 0xFFFFFFFF;
  /// No address
  int get INADDR_NONE => 0xFFFFFFFF;

  /// IP Protocol
  int get IPPROTO_IP => 0;
  /// TCP Protocol
  int get IPPROTO_TCP => 6;
  /// UDP Protocol
  int get IPPROTO_UDP => 17;

  /// Host to network short
  int htons(int hostshort) => ((hostshort >> 8) & 0xFF) | ((hostshort & 0xFF) << 8);
  /// Host to network long
  int htonl(int hostlong) => ((hostlong >> 24) & 0xFF) | ((hostlong >> 8) & 0xFF00) | ((hostlong & 0xFF00) << 8) | ((hostlong & 0xFF) << 24);
  /// Network to host short
  int ntohs(int netshort) => htons(netshort);
  /// Network to host long
  int ntohl(int netlong) => htonl(netlong);
}

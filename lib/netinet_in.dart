import 'src/stdc_base.dart';

class in_addr {
  int s_addr = 0;
}

class sockaddr_in {
  int sin_family = 0;
  int sin_port = 0;
  in_addr sin_addr = in_addr();
  List<int> sin_zero = List.filled(8, 0);
}

extension NetinetInStdc on Stdc {
  int get INADDR_ANY => 0x00000000;
  int get INADDR_BROADCAST => 0xFFFFFFFF;
  int get INADDR_NONE => 0xFFFFFFFF;

  int get IPPROTO_IP => 0;
  int get IPPROTO_TCP => 6;
  int get IPPROTO_UDP => 17;

  int htons(int hostshort) => ((hostshort >> 8) & 0xFF) | ((hostshort & 0xFF) << 8);
  int htonl(int hostlong) => ((hostlong >> 24) & 0xFF) | ((hostlong >> 8) & 0xFF00) | ((hostlong & 0xFF00) << 8) | ((hostlong & 0xFF) << 24);
  int ntohs(int netshort) => htons(netshort);
  int ntohl(int netlong) => htonl(netlong);
}

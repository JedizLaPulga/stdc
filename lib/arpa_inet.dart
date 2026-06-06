// ignore_for_file: camel_case_types, non_constant_identifier_names, constant_identifier_names
import 'src/stdc_base.dart';
import 'netinet_in.dart';

/// ARPA internet operations
extension ArpaInetStdc on Stdc {
  /// Convert IP string to network byte order integer
  int inet_addr(String cp) {
    final parts = cp.split('.');
    if (parts.length != 4) return INADDR_NONE;
    try {
      int a = int.parse(parts[0]);
      int b = int.parse(parts[1]);
      int c = int.parse(parts[2]);
      int d = int.parse(parts[3]);
      return (a | (b << 8) | (c << 16) | (d << 24));
    } catch (_) {
      return INADDR_NONE;
    }
  }

  /// Convert network byte order integer to IP string
  String inet_ntoa(in_addr inAddr) {
    int s = inAddr.s_addr;
    return '${s & 0xFF}.${(s >> 8) & 0xFF}.${(s >> 16) & 0xFF}.${(s >> 24) & 0xFF}';
  }
}

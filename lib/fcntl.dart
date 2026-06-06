import 'src/stdc_base.dart';

/// POSIX file control flags
extension FcntlStdc on Stdc {
  int get O_RDONLY => 0x0000;
  int get O_WRONLY => 0x0001;
  int get O_RDWR   => 0x0002;
  int get O_CREAT  => 0x0040;
  int get O_EXCL   => 0x0080;
  int get O_TRUNC  => 0x0200;
  int get O_APPEND => 0x0400;
  int get O_NONBLOCK => 0x0800;
  int get O_SYNC   => 0x1000;
}

import 'package:stdc/stdc.dart';
import 'package:test/test.dart' as t;

void main() {
  t.group('<pwd.h> and <grp.h>', () {
    t.test('getpwuid and getpwnam', () {
      final rootUser = stdc.getpwuid(0);
      t.expect(rootUser, t.isNotNull);
      t.expect(rootUser!.pw_name, t.equals('root'));
      t.expect(rootUser.pw_uid, t.equals(0));
      t.expect(rootUser.pw_dir, t.equals('/root'));

      final defaultUser = stdc.getpwuid(1000);
      t.expect(defaultUser, t.isNotNull);
      t.expect(defaultUser!.pw_uid, t.equals(1000));
      t.expect(defaultUser.pw_name, t.isNotEmpty);
      
      final byName = stdc.getpwnam(defaultUser.pw_name);
      t.expect(byName, t.isNotNull);
      t.expect(byName!.pw_uid, t.equals(1000));
    });

    t.test('getgrgid and getgrnam', () {
      final rootGroup = stdc.getgrgid(0);
      t.expect(rootGroup, t.isNotNull);
      t.expect(rootGroup!.gr_name, t.equals('root'));
      t.expect(rootGroup.gr_gid, t.equals(0));
      t.expect(rootGroup.gr_mem, t.contains('root'));

      final usersGroup = stdc.getgrgid(1000);
      t.expect(usersGroup, t.isNotNull);
      t.expect(usersGroup!.gr_name, t.equals('users'));
      t.expect(usersGroup.gr_gid, t.equals(1000));
      
      final byName = stdc.getgrnam('users');
      t.expect(byName, t.isNotNull);
      t.expect(byName!.gr_gid, t.equals(1000));
    });
  });
}

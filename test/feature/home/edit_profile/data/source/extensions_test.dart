import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';

// DateTimeExtensions.age reads DateTime.now() directly (no injectable
// clock), so fixtures are built relative to "now" rather than fixed
// calendar dates — this is the reference implementation web's C3 age fix
// ported (currentYear - birthYear alone shows everyone a year too old
// before their birthday).
void main() {
  group('DateTimeExtensions.age', () {
    final now = DateTime.now();
    final turned25Today = DateTime(now.year - 25, now.month, now.day);

    test('birthday is today', () {
      expect(turned25Today.age, 25);
    });

    test('birthday was yesterday', () {
      expect(turned25Today.subtract(const Duration(days: 1)).age, 25);
    });

    test('birthday is tomorrow — hasn\'t turned this year\'s age yet', () {
      expect(turned25Today.add(const Duration(days: 1)).age, 24);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/common/utils/birth_date.dart';

void main() {
  final today = DateTime(2026, 10, 17);

  String? check(String year, String month, String day) =>
      birthDateError(year: year, month: month, day: day, now: today);

  group('age', () {
    test('lets someone through on their 18th birthday', () {
      expect(check('2008', '10', '17'), isNull);
    });

    test('refuses someone who turns 18 tomorrow', () {
      expect(check('2008', '10', '18'), contains('18'));
    });

    test('refuses a birth year that is 18 years back but not yet 18', () {
      // The old check compared years only and let this through.
      expect(check('2008', '12', '31'), contains('18'));
    });

    test('accepts an adult', () {
      expect(check('1998', '06', '15'), isNull);
    });
  });

  group('date', () {
    test('refuses days that do not exist in that month', () {
      expect(check('2000', '02', '31'), 'That date does not exist');
      expect(check('2001', '02', '29'), 'That date does not exist');
      expect(check('2000', '04', '31'), 'That date does not exist');
    });

    test('accepts a leap day', () {
      expect(check('2000', '02', '29'), isNull);
    });

    test('refuses month and day zero or past the end of the range', () {
      expect(check('2000', '13', '01'), 'That date does not exist');
      expect(check('2000', '00', '10'), 'That date does not exist');
      expect(check('2000', '05', '00'), 'That date does not exist');
    });

    test('refuses a year in the future or more than 100 years back', () {
      expect(check('2027', '01', '01'), 'Enter a valid birth year');
      expect(check('1925', '01', '01'), 'Enter a valid birth year');
    });

    test('asks for the full date when a part is missing', () {
      expect(check('', '', ''), 'Enter your full date of birth');
      expect(check('1998', '', '15'), 'Enter your full date of birth');
    });
  });
}

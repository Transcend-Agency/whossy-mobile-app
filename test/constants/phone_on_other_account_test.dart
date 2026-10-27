import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/constants/strings.dart';

void main() {
  group('AppStrings.phoneOnOtherAccount', () {
    test('names how the account signs in', () {
      expect(AppStrings.phoneOnOtherAccount('google'), contains('signs in with Google'));
      expect(AppStrings.phoneOnOtherAccount('apple'), contains('signs in with Apple'));
      expect(AppStrings.phoneOnOtherAccount('local'), contains('email and password'));
      expect(AppStrings.phoneOnOtherAccount('email'), contains('email and password'));
    });

    test('still makes sense when the method is unknown', () {
      expect(AppStrings.phoneOnOtherAccount(null), contains('the way you signed up'));
    });
  });
}

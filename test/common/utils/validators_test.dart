import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/common/utils/extensions.dart';

void main() {
  group('validateNewPassword', () {
    test('accepts any special character the checklist accepts', () {
      expect('Whossy#2026'.validateNewPassword(), isNull);
      expect('Whossy@2026'.validateNewPassword(), isNull);
      expect('Whossy_2026'.validateNewPassword(), isNull);
    });

    test('says why a password is refused', () {
      expect(''.validateNewPassword(), 'Password is required');
      expect('whossy2026!'.validateNewPassword(), isNotNull);
      expect('Whossy!!!!'.validateNewPassword(), isNotNull);
      expect('Wh0!'.validateNewPassword(), isNotNull);
    });
  });

  group('validateCountry', () {
    test('accepts every name the country picker can return', () {
      for (final name in [
        'Togo',
        'Cuba',
        'Nigeria',
        "Côte d'Ivoire",
        'Guinea-Bissau',
      ]) {
        expect(name.validateCountry(), isNull, reason: name);
      }
    });

    test('refuses an empty choice', () {
      expect(''.validateCountry(), isNotNull);
      expect('   '.validateCountry(), isNotNull);
    });
  });
}

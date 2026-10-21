import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/feature/home/edit_profile/model/core_profile.dart';
import 'package:whossy_app/feature/home/edit_profile/model/profile_completion.dart';
import 'package:whossy_app/feature/home/preferences/model/core_preferences.dart';

void main() {
  test('an empty profile is 0% complete', () {
    expect(profileCompletionPercent(CoreProfile(), CorePreferences()), 0);
    expect(profileCompletionPercent(null, null), 0);
  });

  test('counts the profile fields that are filled in', () {
    final profile = CoreProfile(
      firstName: 'Ada',
      lastName: 'Tester',
      gender: 'Female',
      phoneNumber: '+12025550101',
      interests: ['Art'],
    );

    expect(filledProfileFields(profile, CorePreferences()), 5);
    // 5 of 19 fields, rounded up like the web app.
    expect(profileCompletionPercent(profile, CorePreferences()), 27);
  });

  test('blank text and empty lists do not count', () {
    final profile = CoreProfile(
      firstName: '  ',
      bio: '',
      interests: [],
    );

    expect(filledProfileFields(profile, CorePreferences()), 0);
  });
}

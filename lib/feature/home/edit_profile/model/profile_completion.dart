import '../../preferences/model/core_preferences.dart';
import 'core_profile.dart';

/// The profile fields that count toward "% complete". Same 19 as the web app
/// (`checkUserProfileCompletion`), so both show the same number.
const int profileCompletionFields = 19;

/// How many of the 19 fields are filled in.
int filledProfileFields(CoreProfile? profile, CorePreferences? prefs) {
  bool text(String? v) => v != null && v.trim().isNotEmpty;
  bool list(List<String>? v) => v != null && v.isNotEmpty;

  return [
    text(profile?.firstName),
    text(profile?.lastName),
    text(profile?.gender),
    text(profile?.phoneNumber),
    list(profile?.interests),
    prefs?.education != null,
    prefs?.relationshipPreference != null,
    prefs?.loveLanguage != null,
    prefs?.zodiac != null,
    prefs?.futureFamilyPlans != null,
    profile?.height != null,
    profile?.weight != null,
    prefs?.religion != null,
    prefs?.smoker != null,
    prefs?.drinking != null,
    prefs?.workout != null,
    prefs?.petOwner != null,
    prefs?.maritalStatus != null,
    text(profile?.bio),
  ].where((filled) => filled).length;
}

/// Whole-number percentage, rounded up like the web app.
int profileCompletionPercent(CoreProfile? profile, CorePreferences? prefs) =>
    (filledProfileFields(profile, prefs) * 100 / profileCompletionFields)
        .ceil();

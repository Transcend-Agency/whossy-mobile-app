import '../../model/core_settings_text.dart';

List<CoreSettingsText> coreSettingItems = [
  CoreSettingsText(
    title: 'Incognito',
    subtitle:
        'Your profile will be hidden from public users but will be seen by people you like.',
    isPremium: true,
  ),
  CoreSettingsText(
    title: 'Incoming messages',
    subtitle: 'This will allow only verified users to message you.',
  ),
  CoreSettingsText(
    title: 'Hide verification badge',
    subtitle: 'This will hide the verification badge on your profile.',
  ),
  CoreSettingsText(
    title: 'Public search',
    subtitle:
        'Other users will be able to find your profile online when they search the internet.',
  ),
  CoreSettingsText(
    title: 'Online status',
    subtitle: 'Users won’t be able to see when you’re online.',
    isPremium: true,
  ),
];

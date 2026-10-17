// Individual Providers
import 'package:provider/provider.dart';

import 'provider.dart';

final onboardingProvider = ChangeNotifierProvider(
  create: (_) => OnboardingNotifier(),
);

final signUpProvider = ChangeNotifierProvider(
  create: (_) => SignUpNotifier(),
);

final loginProvider = ChangeNotifierProvider(
  create: (_) => LoginNotifier(),
);

final preferencesProvider = ChangeNotifierProvider(
  create: (_) => PreferencesNotifier(),
);

final settingsProvider = ChangeNotifierProvider(
  create: (_) => SettingsNotifier(),
);

final editProfileProvider = ChangeNotifierProvider(
  create: (_) => EditProfileNotifier(),
);

final advancedSearchProvider = ChangeNotifierProvider(
  create: (_) => AdvancedSearchNotifier(),
);

final connectivityProvider = ChangeNotifierProvider(
  create: (_) => ConnectivityNotifier(),
);

final likesProvider = ChangeNotifierProvider(
  create: (_) => LikesNotifier(),
);

final matchesProvider = ChangeNotifierProvider(
  create: (_) => MatchesNotifier(),
);

final notificationProvider = ChangeNotifierProvider(
  create: (_) => NotificationNotifier(),
);

final reportProvider = ChangeNotifierProvider(
  create: (_) => ReportNotifier(),
);

final tourProvider = ChangeNotifierProvider(
  create: (_) => TourNotifier(),
);
// Proxy Providers
final chatsProvider = ChangeNotifierProxyProvider2<EditProfileNotifier,
    ConnectivityNotifier, ChatsNotifier>(
  create: (_) => ChatsNotifier(),
  update: (_, profileData, networkStatus, chatNotifier) {
    return chatNotifier!
      ..saveProfile(profileData.staticProfile)
      ..updateConnectivity(networkStatus.isConnected);
  },
);

final swipeAndMatchProvider = ChangeNotifierProxyProvider2<EditProfileNotifier,
    PreferencesNotifier, SwipeAndMatchNotifier>(
  create: (_) => SwipeAndMatchNotifier(),
  update: (_, profileData, preferences, swipeAndMatch) {
    return swipeAndMatch!
      ..saveProfile(profileData.staticProfile)
      ..saveFilters(
        preferences.staticCorePreferences,
        preferences.staticOtherPreferences,
      );
  },
);

final exploreProvider = ChangeNotifierProxyProvider2<EditProfileNotifier,
    AdvancedSearchNotifier, ExploreNotifier>(
  create: (_) => ExploreNotifier(),
  update: (_, profileData, advancedSearchPrefs, explore) {
    return explore!
      ..saveProfile(profileData.staticProfile)
      ..saveFilters(
        advancedSearchPrefs.staticCorePreferences,
        advancedSearchPrefs.staticOtherPreferences,
      );
  },
);

// List of all providers
final appProviders = [
  onboardingProvider,
  signUpProvider,
  loginProvider,
  preferencesProvider,
  settingsProvider,
  editProfileProvider,
  connectivityProvider,
  advancedSearchProvider,
  likesProvider,
  matchesProvider,
  notificationProvider,
  reportProvider,
  tourProvider,
  chatsProvider,
  swipeAndMatchProvider,
  exploreProvider,
];

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';

import '../../../../auth/onboarding/model/preferences.dart';
import '../../../../auth/sign_up/model/app_user.dart';
import 'profile_data_footer.dart';

// In a scenario where I want to fetch all the users
class UserProfile implements ProfileDataFooter {
  final AppUser user;
  final Preferences preferences;

  UserProfile({required this.user, required this.preferences});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      user: AppUser.fromJson(json),
      preferences: Preferences.fromJson(json),
    );
  }

  @override
  bool get isOnline => user.status?.isRecentlyOnline(Timestamp.now()) ?? false;

  @override
  bool get newUser {
    // Convert TimestampWrapper to Timestamp
    final timestamp = user.createdAt?.toTimestamp();

    // Check if timestamp is valid and calculate the difference
    return timestamp != null &&
        DateTime.now().difference(timestamp.toDate()).inDays <= 7;
  }

  @override
  String get name => user.firstName ?? " ";

  @override
  int get userAge => preferences.dateOfBirth?.age ?? 0;

  @override
  String? get userBio => preferences.bio;

  @override
  List<String> get pictures => preferences.profilePics ?? [];

  // No viewer-location context at this layer to compute a real distance
  // (this model doesn't carry the viewer's own coordinates) — null is
  // honest about that; the fixed 22.0 this replaces was not (C3). The real
  // computed distance for display lives in ProfileFooterScaffold, which
  // does have the viewer's location via EditProfileNotifier.
  @override
  double? get distance => null;

  @override
  List<String> get userInterests => preferences.ticks ?? [];

  @override
  bool get premiumUser => user.isPremium ?? false;

  @override
  bool get isUserVerified => user.isApproved;

  @override
  int? get relationshipPreference => preferences.relationshipPref;

  @override
  GeoPoint? get location => user.geography?.geopoint;
}

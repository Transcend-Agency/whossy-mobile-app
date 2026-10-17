import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';

import '../../preferences/model/core_preferences.dart';
import '../../tabs/matching/model/profile_data_footer.dart';
import 'core_profile.dart';

class EditProfileData extends ProfileDataFooter {
  final CoreProfile profile;
  final CorePreferences preferences;

  EditProfileData(this.profile, this.preferences);

  @override
  bool get isOnline => true;

  @override
  bool? get newUser => null;

  @override
  String get name => profile.firstName ?? " ";

  @override
  int get userAge => profile.dateOfBirth?.age ?? 0;

  @override
  String? get userBio => profile.bio;

  @override
  List<String> get pictures => profile.profilePics ?? [];

  @override
  double? get distance => null;

  @override
  List<String> get userInterests => profile.interests ?? [];

  @override
  bool get premiumUser => profile.isPremium ?? false;

  @override
  bool get isUserVerified => profile.isApproved ?? false;

  @override
  int? get relationshipPreference => preferences.relationshipPreference?.index;

  @override
  GeoPoint? get location => profile.geography?.geopoint;
}

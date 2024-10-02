import 'package:whossy_app/feature/home/edit_profile/model/core_profile.dart';

import '../../../../../../common/utils/index.dart';
import '../../../../preferences/model/core_preferences.dart';

final dummyProfile = CoreProfile(
  profilePics: [
    'https://firebasestorage.googleapis.com/v0/b/whossy-app.appspot.com/o/users%2FAy2YNO2JnYePExiVo7AGnrkupE22%2Fprofile_pictures%2F1725817163218?alt=media&token=2c45fd89-c416-458e-a928-8cd8245cc9b9'
  ],
  gender: 'Male',
  bio: 'This is a sample bio.',
  interests: ['Coding', 'Football', 'Music'],
  dateOfBirth: DateTime(2000, 1, 1), // Example: January 1st, 2000
  firstName: 'Bamidele',
);

final dummyPreferences = CorePreferences(
  relationshipPreference: Preference.justForFun,
  education: School.currentlySchooling,
  futureFamilyPlans: FutureFamilyPlans.hasChildren,
  communicationStyle: CommunicationStyle.friendlyAndOpen,
  loveLanguage: LoveLanguage.heartfeltCompliments,
  smoker: Smoke.frequent,
  drinking: Drink.no,
  workout: WorkOut.occasionally,
  petOwner: PetOwner.bird,
);

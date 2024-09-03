import 'package:whossy_app/feature/home/preferences/model/generic_enum.dart';

import '../../../../../common/utils/index.dart';
import '../../../preferences/data/source/options.dart';

List<CorePreferencesData> editProfileData = [
  CorePreferencesData<School>(
    header: 'Education',
    items: Options.schoolOptions,
  ),
  CorePreferencesData<LoveLanguage>(
    header: 'Love language',
    items: Options.loveOptions,
  ),
  CorePreferencesData<Zodiac>(
    header: 'Zodiac',
    items: Options.zodiacOptions,
  ),
  CorePreferencesData<FutureFamilyPlans>(
    header: 'Future family plans',
    items: Options.familyPlanOptions,
  ),
  CorePreferencesData<CommunicationStyle>(
    header: 'How you communicate',
    items: Options.communicationStyleOptions,
  ),
  CorePreferencesData<Religion>(
    header: 'Religion',
    items: Options.religionOptions,
  ),
  CorePreferencesData<Dietary>(
    header: 'Dietary',
    items: Options.dietaryOptions,
  ),
  CorePreferencesData<Smoke>(
    header: 'Smoker',
    items: Options.smokeOptions,
  ),
  CorePreferencesData<Drink>(
    header: 'Drinking',
    items: Options.drinkOptions,
  ),
  CorePreferencesData<WorkOut>(
    header: 'Workout',
    items: Options.workoutOptions,
  ),
  CorePreferencesData<PetOwner>(
    header: 'Pet owner',
    items: Options.petOwnerOptions,
  ),
  CorePreferencesData<MaritalStatus>(
    header: 'Marital Status',
    items: Options.maritalStatusOptions,
  ),
];

final relationshipData = CorePreferencesData<Preference>(
  header: 'Relationship preference',
  items: Options.relPrefOptions,
);

final genderData = CorePreferencesData<Gender>(
  header: 'Gender',
  items: Options.genderOptions,
);

part of 'core_preferences.dart';

extension CorePreferencesUtils on CorePreferences {
  GenericEnum? getValue(Type type) {
    final selectedValues = <Type, GenericEnum?>{
      Preference: relationshipPreference,
      School: education,
      LoveLanguage: loveLanguage,
      Zodiac: zodiac,
      FutureFamilyPlans: futureFamilyPlans,
      CommunicationStyle: communicationStyle,
      Smoke: smoker,
      Drink: drinking,
      WorkOut: workout,
      PetOwner: petOwner,
      Religion: religion,
      Dietary: dietary,
      MaritalStatus: maritalStatus,
    };

    return selectedValues[type];
  }

  void setValue(GenericEnum value) {
    if (value is Preference) {
      relationshipPreference = value;
    } else if (value is School) {
      education = value;
    } else if (value is LoveLanguage) {
      loveLanguage = value;
    } else if (value is Zodiac) {
      zodiac = value;
    } else if (value is FutureFamilyPlans) {
      futureFamilyPlans = value;
    } else if (value is CommunicationStyle) {
      communicationStyle = value;
    } else if (value is Smoke) {
      smoker = value;
    } else if (value is Drink) {
      drinking = value;
    } else if (value is WorkOut) {
      workout = value;
    } else if (value is PetOwner) {
      petOwner = value;
    } else if (value is Religion) {
      religion = value;
    } else if (value is Dietary) {
      dietary = value;
    } else if (value is MaritalStatus) {
      maritalStatus = value;
    } else {
      // Do nothing
    }
  }
}

part of 'preferences.dart';

extension PreferencesUtils on Preferences {
  void update({
    int? relationshipPref,
    int? meet,
    DateTime? dateOfBirth,
    int? search,
    List<String>? ticks,
    int? drink,
    int? smoker,
    int? education,
    int? loveLanguage,
    int? communicationStyle,
    int? zodiac,
    int? religion,
    int? dietary,
    int? futureFamilyPlans,
    int? workOut,
    int? petOwner,
    String? bio,
    int? maritalStatus,
    List<String>? profilePics,
    List<File>? picFiles,
    File? verPicFile,
  }) {
    if (relationshipPref != null) this.relationshipPref = relationshipPref;
    if (meet != null) this.meet = meet;
    if (dateOfBirth != null) this.dateOfBirth = dateOfBirth;
    if (search != null) this.search = search;
    if (ticks != null) this.ticks = ticks;
    if (drink != null) this.drink = drink;
    if (smoker != null) this.smoker = smoker;
    if (education != null) this.education = education;
    if (loveLanguage != null) this.loveLanguage = loveLanguage;
    if (communicationStyle != null) {
      this.communicationStyle = communicationStyle;
    }
    if (zodiac != null) this.zodiac = zodiac;
    if (religion != null) this.religion = religion;
    if (dietary != null) this.dietary = dietary;
    if (futureFamilyPlans != null) this.futureFamilyPlans = futureFamilyPlans;
    if (workOut != null) this.workOut = workOut;
    if (petOwner != null) this.petOwner = petOwner;
    if (bio != null) this.bio = bio;
    if (maritalStatus != null) this.maritalStatus = maritalStatus;
    if (profilePics != null) this.profilePics = profilePics;
    if (picFiles != null) this.picFiles = picFiles;
    if (verPicFile != null) this.verPicFile = verPicFile;
  }
}

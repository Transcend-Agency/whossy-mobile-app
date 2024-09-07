import 'package:flutter/foundation.dart';

import '../../../../../common/utils/index.dart';
import '../../model/core_profile.dart';

extension CoreProfileExtension on CoreProfile {
  Map<String, dynamic> diff(CoreProfile other) {
    final Map<String, dynamic> updatedFields = {};

    if (firstName != other.firstName) {
      updatedFields['first_name'] = firstName;
    }
    if (lastName != other.lastName) {
      updatedFields['last_name'] = lastName;
    }
    if (gender != other.gender) {
      updatedFields['gender'] = gender;
    }
    if (email != other.email) {
      updatedFields['email'] = email;
    }
    if (phoneNumber != other.phoneNumber) {
      updatedFields['phone_number'] = phoneNumber;
    }
    if (!listEquals(profilePics, other.profilePics)) {
      updatedFields['photos'] = profilePics;
    }
    if (bio != other.bio) {
      updatedFields['bio'] = bio;
    }
    if (weight != other.weight) {
      updatedFields['weight'] = weight;
    }
    if (height != other.height) {
      updatedFields['height'] = height;
    }
    if (!AppUtils.areListsEqual(interests, other.interests)) {
      updatedFields['interests'] = interests;
    }

    return updatedFields;
  }
}

extension StringExtension on String {
  bool get isUrl {
    return startsWith('http://') ||
        startsWith('https://') ||
        startsWith('www.');
  }
}

extension DateTimeExtensions on DateTime {
  int get age {
    DateTime today = DateTime.now();
    int age = today.year - year;

    // Check if the birthday has not occurred yet this year
    if (today.month < month || (today.month == month && today.day < day)) {
      age--;
    }

    return age;
  }
}

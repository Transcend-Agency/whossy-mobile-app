import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'enums.dart';

extension GenderExtension on Gender? {
  IconData get icon {
    switch (this) {
      case Gender.male:
        return Icons.male_rounded;
      case Gender.female:
        return Icons.female_rounded;
      default:
        return Icons.help;
    }
  }
}

extension PreferenceExtension on Preference? {
  String get pref {
    switch (this) {
      case Preference.lookingToDate:
        return 'Looking to Date';
      case Preference.chattingAndConnecting:
        return 'Chatting and Connecting';
      case Preference.readyForCommitment:
        return 'Ready for Commitment';
      case Preference.justForFun:
        return 'Just for Fun';
      case Preference.undecidedOrExploring:
        return 'Undecided or Exploring';
      case null:
        return 'Not specified';
    }
  }
}

extension StringExtention on String? {
  /// Validate the email input (checks if it's a valid email format)
  String? validateEmail() {
    if (this != null && !EmailValidator.validate(this!)) {
      return 'Enter a valid email';
    }
    return null; // Return null if the email is valid
  }

  bool validatePassword() {
    final requirements = [
      RegExp(r'.{8,}'),
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])'),
      RegExp(r'(?=.*\d)'),
      RegExp(r'(?=.*[@$!%*?&])'),
    ];

    for (var regex in requirements) {
      if (!regex.hasMatch(this!)) return false;
    }
    return true;
  }

  String? validateConfirmPassword(TextEditingController password) {
    if (this == null || this!.isEmpty) {
      return 'Confirm password is required';
    }
    if (this != password.text) {
      return 'Passwords do not match';
    }
    return null; // Return null if input is valid
  }

  String? validateName() {
    if (this == null || this!.isEmpty) {
      return 'Cannot be empty';
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(this!)) {
      return 'Name must contain only letters and spaces';
    }
    return null; // Return null if the name is valid
  }

  bool validatePhoneNumberInput() {
    final value = this?.trim();
    if (value == null || value.isEmpty) {
      return false;
    } else if (!RegExp(r'^\+?[0-9 -]+$').hasMatch(value)) {
      return false;
    } else if (value.length != 12) {
      return false;
    } else {
      return true;
    }
  }

  String? validatePhoneNumber(String? existingPhoneNumber) {
    final value = this?.trim();
    if (value == null || value.isEmpty) {
      return 'Enter a phone number';
    } else if (!RegExp(r'^\+?[0-9 -]+$').hasMatch(value)) {
      return 'Invalid character';
    } else if (value.length != 12) {
      return 'Invalid length';
    } else {
      return existingPhoneNumber;
    }
  }

  String formatNumber(String countryCode) {
    // Remove all whitespace from the string
    final cleanNumber = this?.replaceAll(RegExp(r'\s+'), '') ?? '';
    // Concatenate the country code to the front
    return '$countryCode$cleanNumber';
  }

  /// Validate if the string is not empty, has more than 4 characters, and does not contain special characters
  String? validateCountry() {
    final value = this?.trim();
    if (value == null || value.isEmpty) {
      return 'Country name cannot be empty';
    } else if (value.length <= 4) {
      return 'Country name must be more than 4 characters';
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Country name cannot contain special characters';
    }
    return null; // Return null if the country name is valid
  }

  // Validate if the string represents a valid month
  bool isValidMonth() {
    final int? value = int.tryParse(this!);
    return value != null && value >= 1 && value <= 12;
  }

  // Validate if the string represents a valid day
  bool isValidDay() {
    final int? value = int.tryParse(this!);
    return value != null && value >= 1 && value <= 31;
  }

  // Validate if the string represents a valid year within the range of the current year to 100 years back
  bool isValidYear() {
    final int? value = int.tryParse(this!);
    final int currentYear = DateTime.now().year;
    final int minYear = currentYear - 100;
    return value != null && value >= minYear && value <= currentYear - 10;
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'index.dart';

extension StringExtention on String? {
  /// Validate the email input (checks if it's a valid email format)
  String? validateEmail() {
    if (this != null && !EmailValidator.validate(this!)) {
      return 'Enter a valid email';
    }
    return null; // Return null if the email is valid
  }

  String? checkLoginPassword() {
    if (this == null || this!.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  String? checkPassword() {
    if (this == null || this!.isEmpty) {
      return 'Confirm password is required';
    }
    return null;
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
    return value != null && value >= minYear && value <= currentYear - 18;
  }

  // Validate if the string represents a valid university name
  bool isValidUniversity() {
    final value = this?.trim();
    return value != null &&
        value.isNotEmpty &&
        value.length > 4 &&
        RegExp(r'^[a-zA-Z\s]+$').hasMatch(value);
  }

  bool isValidBio() {
    final value = this?.trim();
    return value != null &&
        value.isNotEmpty &&
        value.length >= 10 &&
        value.length <= 500 &&
        RegExp(r'^[a-zA-Z0-9\s,.!?\-]+$').hasMatch(value);
  }

  /// Validate the bio input (checks if it's a valid bio format)
  String? validateBio() {
    final value = this?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 10 || value.length > 500) {
      return 'At least 10 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s,.!?\-]+$').hasMatch(value)) {
      return 'Special characters are not allowed';
    }
    return null; // Return null if the bio is valid
  }

  String toReadableFormat() {
    // Convert camelCase to spaced words
    final spacedField =
        this!.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    }).replaceAll('_', ' ');

    // Capitalize the first letter of each word
    final formattedField = spacedField.split(' ').map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      }
      return '';
    }).join(' ');

    // Handle specific cases for formatting
    return formattedField == 'Phone Number' ? 'Phone number' : formattedField;
  }
}

extension RangeValuesExtension1 on Map<String, int>? {
  RangeValues? toRangeValues() {
    final min = this?['min'];
    final max = this?['max'];
    if (min == null || max == null) {
      return null;
    }
    return RangeValues(min.toDouble(), max.toDouble());
  }

  String displayRange({RangeType type = RangeType.height}) {
    String convertToFeetInches(int cm) {
      final totalInches = (cm / 2.54).round();
      final feet = totalInches ~/ 12;
      final inches = totalInches % 12;
      return "$feet'$inches\"";
    }

    String convertKgToPounds(int kg) {
      final pounds = (kg * 2.20462).round(); // Convert kg to pounds
      return '$pounds lbs';
    }

    if (this?['min'] == null || this?['max'] == null) {
      return 'Choose';
    }

    final minValue = this!['min'];
    final maxValue = this!['max'];

    return type == RangeType.height
        ? '${convertToFeetInches(minValue!)} - ${convertToFeetInches(maxValue!)}'
        : type == RangeType.weight
            ? '${convertKgToPounds(minValue!)} - ${convertKgToPounds(maxValue!)}'
            : 'Invalid type';
  }
}

extension RangeValuesExtension2 on RangeValues {
  String getFormattedRange({RangeType type = RangeType.height}) {
    String convertCmToInches(double cm) {
      final totalInches = (cm / 2.54).round();
      final feet = totalInches ~/ 12;
      final inches = totalInches % 12;
      return "$feet'$inches\"";
    }

    String convertKgToPounds(double kg) {
      final pounds = (kg * 2.20462).round();
      return '$pounds lbs';
    }

    final minValue = start.round();
    final maxValue = end.round();

    if (type == RangeType.height) {
      final minHeightInches = convertCmToInches(start);
      final maxHeightInches = convertCmToInches(end);
      return '${minValue}cm ($minHeightInches) - ${maxValue}cm ($maxHeightInches)';
    } else if (type == RangeType.weight) {
      final minWeightLbs = convertKgToPounds(start);
      final maxWeightLbs = convertKgToPounds(end);
      return '${minValue}kg ($minWeightLbs) - ${maxValue}kg ($maxWeightLbs)';
    } else {
      return 'Invalid type';
    }
  }
}

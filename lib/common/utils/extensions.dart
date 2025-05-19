import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';

import 'app_utils.dart';

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
    if (!RegExp(r'^[a-zA-Z\- ]+$').hasMatch(this!)) {
      return 'Name must contain only letters';
    }
    return null; // Return null if the name is valid
  }

  bool validatePhoneNumberInput() {
    final value = this?.trim();
    if (value == null || value.isEmpty) {
      return false;
    } else if (!RegExp(r'^\+?[0-9 -]+$').hasMatch(value)) {
      return false;
    } else if (value.length < 10 || value.length > 14) {
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
    } else if (value.length < 10 || value.length > 14) {
      return 'Invalid length';
    } else {
      return existingPhoneNumber;
    }
  } //

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
      return 'Cannot be empty';
    } else if (value.length <= 4) {
      return 'Must be more than 4 characters';
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Cannot contain special characters';
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
    // Check if bio is null, empty, or out of the valid length range
    final value = this?.trim();
    if (value == null ||
        value.isEmpty ||
        value.length < 10 ||
        value.length > 500) {
      return false;
    }

    // Disallow potentially harmful characters
    final RegExp disallowedChars = RegExp(r'[<>{}[\]]');

    // If the bio contains any harmful characters, it's invalid
    if (disallowedChars.hasMatch(value)) {
      return false;
    }

    // Allow everything else (including emojis)
    return true;
  }

  /// Validate the bio input (checks if it's a valid bio format)
  String? validateBio() {
    final value = this?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }

    // Check if bio is within the valid length range
    if (value.length < 10 || value.length > 500) {
      return 'At least 10 characters';
    }

    // Disallow potentially harmful characters like <, >, {, }
    final RegExp disallowedChars = RegExp(r'[<>{}[\]]');

    if (disallowedChars.hasMatch(value)) {
      return 'Invalid characters used: <, >, {, }, [, ] are not allowed';
    }

    // Allow everything else (including emojis and common special characters)
    return null; // Return null if the bio is valid
  }

  String toReadableFormat() {
    // Convert camelCase to spaced words
    final spacedField =
        this!.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    }).replaceAll('_', ' ');

    // Capitalize the first letter of the first word, leave the others as is
    final words = spacedField.split(' ');
    final formattedField = words.map((word) {
      if (words.indexOf(word) == 0) {
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      } else {
        return word.toLowerCase();
      }
    }).join(' ');

    return formattedField;
  }
}

extension DateTimeFormatting on DateTime {
  String formatWithSuffix() {
    // Get the day of the month
    int day = this.day;

    // Determine the suffix
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }

    // Format the date
    String formattedDate = DateFormat('d MMMM, yyyy').format(this);

    // Append the suffix to the day
    return formattedDate.replaceFirst(RegExp(r'\d+'), '$day$suffix');
  }

  String get monthName {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }
}

extension PrettyPrintJson on Map<String, dynamic> {
  String formatJson() {
    return const JsonEncoder.withIndent('  ').convert(this);
  }
}

extension DistanceFormatter on double {
  String formatDistance() {
    if (this >= 1) {
      return toStringAsFixed(0);
    } else if (this >= 0.1) {
      return toStringAsFixed(1);
    } else if (this >= 0.01) {
      return toStringAsFixed(2);
    } else {
      return toStringAsFixed(3);
    }
  }
}

extension MapContainsKeys on Map {
  bool containsKeys(List<String> keys) {
    return keys.every((key) => containsKey(key));
  }
}

extension CreditProductIdParsing on String {
  int? get creditQty {
    final match = RegExp(r'^credits_(\d+)(?:_.*)?$').firstMatch(this);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }
}

extension SubscriptionPlanExtension on ProductDetails {
  int get months {
    if (id.contains("1months")) return 1;
    if (id.contains("3months")) return 3;
    if (id.contains("6months")) return 6;
    if (id.contains("1year")) return 12;
    return 1;
  }

  String get displayName {
    switch (months) {
      case 1:
        return 'Monthly Plan';
      case 12:
        return '1 Year Plan';
      default:
        return '$months Months Plan';
    }
  }

  String get monthlyRateDisplay {
    final monthsCount = months;
    final monthlyRate = rawPrice / monthsCount;

    return '${formatPrice(monthlyRate, currencyCode)} / mo';
  }

  String totalBilledText() {
    final billingCycle = _billingCycleDescription(months);

    return '${formatPrice(rawPrice, currencyCode)} $billingCycle';
  }

  String _billingCycleDescription(int months) {
    switch (months) {
      case 1:
        return '';
      case 3:
        return 'billed quarterly';
      case 6:
        return 'billed biannually';
      case 12:
        return 'billed yearly';
      default:
        return 'every $months months';
    }
  }
}

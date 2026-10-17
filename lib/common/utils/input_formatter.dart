import 'package:flutter/services.dart';

class InputFormatter {
  // Creates a formatter for months
  static List<TextInputFormatter> month() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(2),
      TextInputFormatter.withFunction(
        (oldValue, newValue) {
          if (newValue.text.isEmpty) {
            return newValue;
          }
          final int value = int.tryParse(newValue.text) ?? 0;
          if (value > 12) {
            return oldValue;
          }
          return newValue;
        },
      ),
    ];
  }

  // Creates a formatter for days
  static List<TextInputFormatter> day() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(2),
      TextInputFormatter.withFunction(
        (oldValue, newValue) {
          if (newValue.text.isEmpty) {
            return newValue;
          }
          final int value = int.tryParse(newValue.text) ?? 0;
          if (value > 31) {
            return oldValue;
          }
          return newValue;
        },
      ),
    ];
  }

  // Creates a formatter for years. The range is not enforced here: a year
  // the field silently refuses leaves the user with no idea why, so the age
  // screen checks the whole date and says what is wrong.
  static List<TextInputFormatter> year() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(4),
    ];
  }
}

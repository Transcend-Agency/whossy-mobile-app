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

  // Creates a formatter for years with a range from current year to 100 years back
  static List<TextInputFormatter> year() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(4),
      TextInputFormatter.withFunction(
        (oldValue, newValue) {
          if (newValue.text.isEmpty) {
            return newValue;
          }
          final int currentYear = DateTime.now().year;
          final int minYear = currentYear - 100;
          final int value = int.tryParse(newValue.text) ?? 0;

          if (newValue.text.length < 4 ||
              (value >= minYear && value <= (currentYear - 10))) {
            return newValue;
          }

          return oldValue;
        },
      ),
    ];
  }
}

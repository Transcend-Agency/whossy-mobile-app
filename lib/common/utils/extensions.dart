import 'package:email_validator/email_validator.dart';

extension StringExtention on String? {
  /// Validate the email input (checks if it's a valid email format)
  String? validateEmail() {
    if (this != null && !EmailValidator.validate(this!)) {
      return 'Enter a valid email';
    }
    return null; // Return null if the email is valid
  }

  /// Validate the input value (length should be at least 6 characters)
  String? validatePassword() {
    if (this == null) {
      return 'Input is required';
    } else if (this!.length < 6) {
      return 'Enter a minimum of 6 characters';
    }
    return null; // Return null if input is valid
  }
}

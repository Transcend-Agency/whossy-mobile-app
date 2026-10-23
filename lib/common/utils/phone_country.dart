import 'package:country_picker/country_picker.dart';

/// A country recognised from the start of a typed phone number, with the
/// rest of the number that follows its dial code.
class PhoneCountryMatch {
  const PhoneCountryMatch(this.country, this.nationalNumber);

  final Country country;
  final String nationalNumber;
}

// Several countries share one dial code; the picker lists them in
// alphabetical order, so the main country is named here.
const _preferredByCode = {
  '1': 'US',
  '7': 'RU',
  '39': 'IT',
  '44': 'GB',
  '47': 'NO',
  '61': 'AU',
  '212': 'MA',
  '262': 'FR',
  '358': 'FI',
  '590': 'FR',
  '599': 'CW',
};

/// Finds the country a number is written for, when it is written in
/// international form: `+234 814…`, `00234814…`, or (only when [allowBare] is
/// set) a long number that begins with a dial code and no leading zero.
/// Returns null for a local number, so the chosen country is left alone.
PhoneCountryMatch? detectPhoneCountry(String input, {bool allowBare = false}) {
  final text = input.trim();
  final digits = text.replaceAll(RegExp(r'\D'), '');

  final String rest;
  if (text.startsWith('+')) {
    rest = digits;
  } else if (text.startsWith('00')) {
    rest = digits.substring(2);
  } else if (allowBare && digits.length >= 12 && !digits.startsWith('0')) {
    // Local numbers rarely run past 11 digits, so a longer one is taken as
    // already carrying its dial code.
    rest = digits;
  } else {
    return null;
  }

  final countries = CountryService().getAll();

  // Dial codes run from one to three digits; take the longest that matches.
  for (var length = 3; length >= 1; length--) {
    if (rest.length < length) continue;

    final code = rest.substring(0, length);
    final matches = countries.where((c) => c.phoneCode == code).toList();

    if (matches.isEmpty) continue;

    final preferred = _preferredByCode[code];
    final country = matches.firstWhere(
      (c) => c.countryCode == preferred,
      orElse: () => matches.first,
    );

    return PhoneCountryMatch(country, rest.substring(length));
  }

  return null;
}

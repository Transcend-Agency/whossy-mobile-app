import 'package:flutter/material.dart' show RangeValues;

import '../../constants/discovery_constants.dart';
import 'birth_date.dart';

/// Ends of the age slider. They are the sign-up age limits, since nobody
/// on Whossy can be younger or older. The same on web.
final kAgeSliderSpan =
    RangeValues(minimumAge.toDouble(), maximumAge.toDouble());

/// Whole years old on [now].
int ageOn(DateTime dateOfBirth, DateTime now) {
  var age = now.year - dateOfBirth.year;
  final hadBirthdayThisYear = now.month > dateOfBirth.month ||
      (now.month == dateOfBirth.month && now.day >= dateOfBirth.day);
  if (!hadBirthdayThisYear) age--;
  return age;
}

/// Where the age range starts when someone first switches the age filter on:
/// [kStartingAgeSpread] years either side of their own age, kept within the
/// slider's ends. Without a date of birth it starts at the whole span.
RangeValues startingAgeRange(DateTime? dateOfBirth, {DateTime? now}) {
  if (dateOfBirth == null) return kAgeSliderSpan;
  final age = ageOn(dateOfBirth, now ?? DateTime.now());
  final min = (age - kStartingAgeSpread).clamp(minimumAge, maximumAge);
  final max = (age + kStartingAgeSpread).clamp(minimumAge, maximumAge);
  return RangeValues(min.toDouble(), max.toDouble());
}

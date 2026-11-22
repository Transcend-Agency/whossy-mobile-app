import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/common/utils/age_filter.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';
import 'package:whossy_app/feature/home/preferences/model/other_preferences.dart';

void main() {
  final now = DateTime(2026, 6, 15);

  group('ageOn', () {
    test('counts whole years, birthday today included', () {
      expect(ageOn(DateTime(1996, 6, 15), now), 30);
      expect(ageOn(DateTime(1996, 6, 16), now), 29);
    });
  });

  group('startingAgeRange', () {
    test('starts 5 years either side of your own age', () {
      expect(startingAgeRange(DateTime(1996, 1, 1), now: now),
          const RangeValues(25, 35));
    });

    test('never goes below 18 or above 100', () {
      expect(startingAgeRange(DateTime(2007, 1, 1), now: now),
          const RangeValues(18, 24));
      expect(startingAgeRange(DateTime(1928, 1, 1), now: now),
          const RangeValues(93, 100));
    });

    test('without a date of birth, starts at every age', () {
      expect(startingAgeRange(null, now: now), kAgeSliderSpan);
    });
  });

  group('OtherPreferences age filter', () {
    const start = RangeValues(25, 35);

    test('is off when no age range is saved', () {
      final prefs = OtherPreferences();
      expect(prefs.isAgeFilterOn, isFalse);
      expect(prefs.myAgeRange, isNull);
    });

    test('switching on the first time uses the starting range', () {
      final prefs = OtherPreferences()
        ..setAgeFilter(true, startingRange: start);
      expect(prefs.ageRange, {'min': 25, 'max': 35});
      expect(prefs.savedAgeRange, {'min': 25, 'max': 35});
    });

    test('switching off keeps the range, and on again restores it', () {
      final prefs = OtherPreferences(ageRange: {'min': 30, 'max': 45})
        ..setAgeFilter(false, startingRange: start);
      expect(prefs.isAgeFilterOn, isFalse);
      expect(prefs.myAgeRange, {'min': 30, 'max': 45});

      prefs.setAgeFilter(true, startingRange: start);
      expect(prefs.ageRange, {'min': 30, 'max': 45});
    });

    test('moving the slider updates the saved range too', () {
      final prefs = OtherPreferences()
        ..setAgeFilter(true, startingRange: start)
        ..update(minAge: 28, maxAge: 40);
      expect(prefs.ageRange, {'min': 28, 'max': 40});
      expect(prefs.savedAgeRange, {'min': 28, 'max': 40});
    });

    test('saving after switching off writes a null age range', () {
      final saved = OtherPreferences(ageRange: {'min': 20, 'max': 40});
      final edited = OtherPreferences.fromJson(saved.toJson())
        ..setAgeFilter(false, startingRange: start);
      expect(edited.diff(saved), {
        'age_range': null,
        'saved_age_range': {'min': 20, 'max': 40},
      });
    });

    test('the saved range survives a round trip through Firestore JSON', () {
      final prefs = OtherPreferences.fromJson({
        'saved_age_range': {'min': 22, 'max': 31},
      });
      expect(prefs.isAgeFilterOn, isFalse);
      expect(OtherPreferences.fromJson(prefs.toJson()), prefs);
    });
  });
}

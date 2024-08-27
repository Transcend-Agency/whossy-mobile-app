// enum_conversions.dart

// Custom methods for each enum type
import '../../../feature/home/preferences/model/generic_enum.dart';
import 'enums.dart';

// Converts enum to index
int? enumToIndex(GenericEnum? enumValue) => enumValue?.index;

Preference? indexToPreference(int? index) =>
    index != null && index >= 0 && index < Preference.values.length
        ? Preference.values[index]
        : null;

School? indexToSchool(int? index) =>
    index != null && index >= 0 && index < School.values.length
        ? School.values[index]
        : null;

LoveLanguage? indexToLoveLanguage(int? index) =>
    index != null && index >= 0 && index < LoveLanguage.values.length
        ? LoveLanguage.values[index]
        : null;

Zodiac? indexToZodiac(int? index) =>
    index != null && index >= 0 && index < Zodiac.values.length
        ? Zodiac.values[index]
        : null;

FutureFamilyPlans? indexToFutureFamilyPlans(int? index) =>
    index != null && index >= 0 && index < FutureFamilyPlans.values.length
        ? FutureFamilyPlans.values[index]
        : null;

CommunicationStyle? indexToCommunicationStyle(int? index) =>
    index != null && index >= 0 && index < CommunicationStyle.values.length
        ? CommunicationStyle.values[index]
        : null;

Smoke? indexToSmoke(int? index) =>
    index != null && index >= 0 && index < Smoke.values.length
        ? Smoke.values[index]
        : null;

Drink? indexToDrink(int? index) =>
    index != null && index >= 0 && index < Drink.values.length
        ? Drink.values[index]
        : null;

WorkOut? indexToWorkOut(int? index) =>
    index != null && index >= 0 && index < WorkOut.values.length
        ? WorkOut.values[index]
        : null;

PetOwner? indexToPetOwner(int? index) =>
    index != null && index >= 0 && index < PetOwner.values.length
        ? PetOwner.values[index]
        : null;

Religion? indexToReligion(int? index) =>
    index != null && index >= 0 && index < Religion.values.length
        ? Religion.values[index]
        : null;

Dietary? indexToDietary(int? index) =>
    index != null && index >= 0 && index < Dietary.values.length
        ? Dietary.values[index]
        : null;

MaritalStatus? indexToMaritalStatus(int? index) =>
    index != null && index >= 0 && index < MaritalStatus.values.length
        ? MaritalStatus.values[index]
        : null;

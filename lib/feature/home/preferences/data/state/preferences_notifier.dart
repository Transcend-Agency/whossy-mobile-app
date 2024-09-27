import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';
import 'package:whossy_app/feature/home/preferences/data/state/search_preferences_notifier.dart';

import '../../../../../constants/index.dart';
import '../../model/core_preferences.dart';
import '../../model/generic_enum.dart';
import '../../model/other_preferences.dart';
import '../repository/filters_repository.dart';

class PreferencesNotifier extends ChangeNotifier
    implements SearchPreferencesNotifier {
  final _prefsRepo = FiltersRepository();

  CorePreferences? _dynCorePrefs;
  CorePreferences? _statCorePrefs;

  OtherPreferences? _dynOtherPrefs;
  OtherPreferences? _statOtherPrefs;

  @override
  CorePreferences? get selectedItems => _dynCorePrefs;

  @override
  OtherPreferences? get otherPreferences => _dynOtherPrefs;

  @override
  void setValue(GenericEnum value) {
    _dynCorePrefs?.setValue(value);
    notifyListeners();
  }

  @override
  String getValue(Type type) => _dynCorePrefs?.getValue(type)?.name ?? 'Choose';
  @override
  GenericEnum? getSelected(Type type) => _dynCorePrefs?.getValue(type);

  @override
  bool get hasChanges {
    if (_dynCorePrefs == null ||
        _statCorePrefs == null ||
        _dynOtherPrefs == null ||
        _statOtherPrefs == null) {
      return false;
    }
    bool corePrefs = _dynCorePrefs != _statCorePrefs;
    bool otherPrefs = _dynOtherPrefs != _statOtherPrefs;

    return corePrefs || otherPrefs;
  }

  @override
  Future<void> getFilters({
    required void Function(String) showSnackbar,
  }) async {
    try {
      final data = await _prefsRepo.fetchFilters();

      _dynCorePrefs = data?.corePreferences ?? CorePreferences();
      _dynOtherPrefs = data?.otherPreferences ?? OtherPreferences();

      _statCorePrefs = CorePreferences.fromJson(_dynCorePrefs!.toJson());

      _statOtherPrefs = OtherPreferences.fromJson(_dynOtherPrefs!.toJson());
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
    } finally {}

    notifyListeners();
  }

  @override
  Future<void> saveFilters({
    required void Function(String) showSnackbar,
  }) async {
    try {
      final coreDiff = _dynCorePrefs?.diff(_statCorePrefs!) ?? {};
      final otherDiff = _dynOtherPrefs?.diff(_statOtherPrefs!) ?? {};

      if (coreDiff.isEmpty && otherDiff.isEmpty) {
        return;
      }

      await _prefsRepo.updateFilters({...coreDiff, ...otherDiff});

      // Once saved, update the static preferences to match the dynamic ones
      _statCorePrefs = CorePreferences.fromJson(_dynCorePrefs!.toJson());
      _statOtherPrefs = OtherPreferences.fromJson(_dynOtherPrefs!.toJson());
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
    } finally {}

    notifyListeners();
  }

  @override
  void updatePreferences({
    int? meet,
    bool? similarInterest,
    bool? hasBio,
    int? minAge,
    int? maxAge,
    double? distance,
    bool? outreach,
    List<String>? interests,
    String? country,
    String? city,
    int? minHeight,
    int? maxHeight,
    int? minWeight,
    int? maxWeight,
  }) {
    _dynOtherPrefs?.update(
      meet: meet,
      similarInterest: similarInterest,
      hasBio: hasBio,
      minAge: minAge,
      maxAge: maxAge,
      distance: distance,
      outreach: outreach,
      interests: interests,
      country: country,
      city: city,
      minHeight: minHeight,
      maxHeight: maxHeight,
      minWeight: minWeight,
      maxWeight: maxWeight,
    );

    notifyListeners();
  }
}

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/common/utils/services/file_service.dart';
import 'package:whossy_app/feature/home/edit_profile/data/repository/edit_profile_repository.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';

import '../../../../../constants/index.dart';
import '../../../../auth/onboarding/model/preferences.dart';
import '../../../../auth/sign_up/model/app_user.dart';
import '../../../preferences/model/core_preferences.dart';
import '../../../preferences/model/generic_enum.dart';
import '../../model/core_profile.dart';

class EditProfileNotifier extends ChangeNotifier {
  CoreProfile? _dynCoreProfile;
  CoreProfile? _staticCoreProfile;

  CorePreferences? _dynCorePrefs;
  CorePreferences? _staticCorePrefs;

  final _editProfileRepo = EditProfileRepository();

  CoreProfile? get coreProfile => _dynCoreProfile;
  CorePreferences? get corePrefs => _dynCorePrefs;

  bool _hasEditFetched = false;

  bool get hasEditFetched => _hasEditFetched;

  set hasEditFetched(bool value) {
    _hasEditFetched = value;

    notifyListeners();
  }

  void resetToStatic() {
    _dynCoreProfile = _staticCoreProfile;
    _dynCorePrefs = _staticCorePrefs;

    notifyListeners();
  }

  void setValue(GenericEnum value) {
    _dynCorePrefs?.setValue(value);
    notifyListeners();
  }

  void _initializeDefaultValues() {
    _dynCoreProfile = CoreProfile();
    _staticCoreProfile = CoreProfile();
    _dynCorePrefs = CorePreferences();
    _staticCorePrefs = CorePreferences();
  }

  dynamic getCoreValue(String k) => _dynCoreProfile?.getValue(k) ?? 'Choose';

  String getValue(Type _) => _dynCorePrefs?.getValue(_)?.name ?? 'Choose';
  GenericEnum? getSelected(Type _) => _dynCorePrefs?.getValue(_);

  bool get hasChanges {
    if (_dynCoreProfile == null ||
        _staticCoreProfile == null ||
        _dynCorePrefs == null ||
        _staticCorePrefs == null) {
      return false;
    }
    bool corePrefs = _dynCoreProfile != _staticCoreProfile;
    bool otherPrefs = _dynCorePrefs != _staticCorePrefs;

    return corePrefs || otherPrefs;
  }

  Future<void> getUserData({
    required void Function(String) showSnackbar,
  }) async {
    try {
      final data = await _editProfileRepo.fetchProfileData();

      // Initialize default values
      _initializeDefaultValues();

      if (data != null) {
        // Update profiles and preferences if available
        if (data.user != null) {
          _updateCoreProfile(data.user!);
        }

        if (data.prefs != null) {
          _updateCorePreferences(data.prefs!);

          // Update _dynCoreProfile with preferences data
          _dynCoreProfile?.updateFromPreferences(data.prefs!);
          _staticCoreProfile = CoreProfile.fromJson(_dynCoreProfile!.toJson());
        }
      }
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveUserProfile({
    required void Function(String) showSnackbar,
  }) async {
    try {
      final corePrefsDiff = _dynCorePrefs?.diff(_staticCorePrefs!) ?? {};
      final coreProfileDiff = _dynCoreProfile?.diff(_staticCoreProfile!) ?? {};

      log('Core prefs $coreProfileDiff, $corePrefsDiff');

      // Iterate through keysToTransfer and transfer matching key-value pairs
      for (final key in CoreProfile.transferKeys) {
        if (coreProfileDiff.containsKey(key)) {
          corePrefsDiff[key] = coreProfileDiff.remove(key);
        }
      }

      if (corePrefsDiff.isEmpty && coreProfileDiff.isEmpty) return;

      if (corePrefsDiff.containsKey("photos")) {
        final photos = corePrefsDiff["photos"];

        if (photos is List) {
          final updatedPhotos =
              await FileService().processPhotos(photos, showSnackbar);

          // Replace the photos list with the updated list
          corePrefsDiff["photos"] = updatedPhotos;
        }
      }

      await _editProfileRepo.updateProfileData(
        corePrefData: {...corePrefsDiff},
        coreProfileData: {...coreProfileDiff},
      );

      // Once saved, update the static preferences to match the dynamic ones
      _staticCorePrefs = CorePreferences.fromJson(_dynCorePrefs!.toJson());
      _staticCoreProfile = CoreProfile.fromJson(_dynCoreProfile!.toJson());
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void updateProfile({
    String? bio,
    String? gender,
    String? firstName,
    String? lastName,
    double? weight,
    double? height,
    List<String>? interests,
    List<String>? profilePics,
  }) {
    _dynCoreProfile?.update(
      bio: bio,
      gender: gender,
      lastName: lastName,
      firstName: firstName,
      weight: weight,
      height: height,
      interests: interests,
      profilePics: profilePics,
    );
    notifyListeners();
  }

  void _updateCoreProfile(AppUser user) {
    _dynCoreProfile = CoreProfile.fromJson(user.toJson());
    _staticCoreProfile = CoreProfile.fromJson(_dynCoreProfile!.toJson());
  }

  void _updateCorePreferences(Preferences prefs) {
    _dynCorePrefs = CorePreferences.fromJson(prefs.toJson());
    _staticCorePrefs = CorePreferences.fromJson(_dynCorePrefs!.toJson());
  }
}

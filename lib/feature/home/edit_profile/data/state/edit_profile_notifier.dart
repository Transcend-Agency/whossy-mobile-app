import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/common/utils/services/services.dart';
import 'package:whossy_app/feature/auth/onboarding/model/face_verification.dart';
import 'package:whossy_app/feature/home/edit_profile/data/repository/edit_profile_repository.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';

import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../../../auth/onboarding/model/preferences.dart';
import '../../../../auth/sign_up/data/repository/user_repository.dart';
import '../../../../auth/sign_up/model/app_user.dart';
import '../../../../auth/sign_up/model/geography.dart';
import '../../../../auth/sign_up/model/payment.dart';
import '../../../preferences/model/core_preferences.dart';
import '../../../preferences/model/generic_enum.dart';
import '../../model/core_profile.dart';
import '../../model/edit_profile_data.dart';

class EditProfileNotifier extends ChangeNotifier {
  final _sharedPrefs = SharedPrefsService();
  final _userRepository = UserRepository();

  CoreProfile? _dynCoreProfile;
  CoreProfile? _staticCoreProfile;

  CorePreferences? _dynCorePrefs;
  CorePreferences? _staticCorePrefs;

  final _editProfileRepo = EditProfileRepository();

  bool _hasSafetyGuideOpened = true;

  bool _didUserDeletePic = false;

  // Setter for _didUserDeletePic
  set didUserDeletePic(bool value) {
    if (value != _didUserDeletePic) {
      _didUserDeletePic = value;

      log('Did user delete pic changed to $_didUserDeletePic');
    }
  }

  // Getter for hasSafetyGuideOpened
  bool get hasSafetyGuideOpened => _hasSafetyGuideOpened;

  // Setter for hasSafetyGuideOpened
  set hasSafetyGuideOpened(bool value) {
    if (_hasSafetyGuideOpened != value) {
      _hasSafetyGuideOpened = value;

      notifyListeners();
    }
  }

  checkSafetyGuideOpenedState() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    hasSafetyGuideOpened =
        !await _sharedPrefs.isFirstTimeOpened(SafetyGuide.name, uid);
  }

  CoreProfile? get coreProfile => _dynCoreProfile;
  CoreProfile? get staticProfile => _staticCoreProfile;
  CorePreferences? get corePrefs => _dynCorePrefs;
  EditProfileData get profileData => EditProfileData(
        _dynCoreProfile!,
        _dynCorePrefs!,
      );

  bool _hasEditFetched = false;

  bool get hasEditFetched => _hasEditFetched;

  set hasEditFetched(bool value) {
    _hasEditFetched = value;

    notifyListeners();
  }

  void resetToStatic() {
    _dynCoreProfile = _staticCoreProfile;
    _dynCorePrefs = _staticCorePrefs;

    didUserDeletePic = false;
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

  String getValue(Type t) => _dynCorePrefs?.getValue(t)?.name ?? 'Choose';
  GenericEnum? getSelected(Type t) => _dynCorePrefs?.getValue(t);

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

  int get picCount => _dynCoreProfile?.profilePics?.length ?? 0;

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

  // This function is used to handle the initial update of a user's location
  // when they first access the swipe and match page.
  //
  // It ensures that the location data is updated locally after user data is fetched,
  // addressing the issue of location not being available on the client side initially.
  void saveUserLocationLocally(
    Position position, {
    required void Function(String) showSnackbar,
  }) {
    try {
      final geo = GeoFlutterFire();

      final geoFirePoint =
          geo.point(latitude: position.latitude, longitude: position.longitude);

      final geoPoint = GeoPoint(position.latitude, position.longitude);

      if (_staticCoreProfile?.geohash == geoFirePoint.hash) return;

      _dynCoreProfile?.updateLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        location: geoPoint,
        geohash: geoFirePoint.hash,
        geography: Geography.fromJson(geoFirePoint.data),
      );

      _staticCoreProfile = CoreProfile.fromJson(_dynCoreProfile!.toJson());
    } catch (e) {
      log('Error updating user location: $e');
      throw LocationServiceException('Error updating location');
    } finally {
      notifyListeners();
    }
  }

  Future<bool> saveUserProfile({
    required void Function(String) showSnackbar,
  }) async {
    try {
      final corePrefsDiff = _dynCorePrefs?.diff(_staticCorePrefs!) ?? {};
      final coreProfileDiff = _dynCoreProfile?.diff(_staticCoreProfile!) ?? {};
      bool hasPicUploads = false;

      if (corePrefsDiff.isEmpty && coreProfileDiff.isEmpty) return true;

      // Process profile photos if available
      hasPicUploads =
          await _processProfilePhotos(coreProfileDiff, showSnackbar);

      // Process face verification if available
      await _processFaceVerification(coreProfileDiff);

      await _editProfileRepo.updateProfileData(
        corePrefData: {...corePrefsDiff},
        coreProfileData: {...coreProfileDiff},
        updateUserDeletePic: _didUserDeletePic,
        hasPicUploads: hasPicUploads,
      );

      // Sync static profile with the latest changes
      _staticCorePrefs = CorePreferences.fromJson(_dynCorePrefs!.toJson());
      _staticCoreProfile = CoreProfile.fromJson(_dynCoreProfile!.toJson());

      return true;
    } catch (e) {
      _handleSaveProfileError(e, showSnackbar);
      return false;
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
    int? creditBalance,
    bool? isPremium,
    Payment? amountPaid,
    List<String>? interests,
    List<String>? profilePics,
    List<String>? blockedIds,
    String? photoVerificationUrl,
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
      isPremium: isPremium,
      blockedIds: blockedIds,
      creditBalance: creditBalance,
      amountPaid: amountPaid,
      photoVerificationUrl: photoVerificationUrl,
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

  Future<bool> _processProfilePhotos(
    Map<String, dynamic> coreProfileDiff,
    void Function(String) showSnackbar,
  ) async {
    if (coreProfileDiff["photos"] is! List<String>) return false;

    final updatedPhotos = await FileService().processPhotos(
      coreProfileDiff["photos"],
      showSnackbar,
    );

    coreProfileDiff["photos"] = updatedPhotos.photos;
    _dynCoreProfile?.update(profilePics: updatedPhotos.photos);
    return updatedPhotos.hasUploads;
  }

  Future<void> _processFaceVerification(
    Map<String, dynamic> coreProfileDiff,
  ) async {
    if (coreProfileDiff["face_verification"] is! FaceVerification) return;

    final faceVerification =
        coreProfileDiff["face_verification"] as FaceVerification;

    if (faceVerification.photo == null) return;

    final photoUrls = await _userRepository.uploadPictures(
      files: [File(faceVerification.photo!)],
      pathGenerator: AppStrings.faceVerPicPath,
    );

    final photoUrl = photoUrls.isNotEmpty ? photoUrls.first : null;

    coreProfileDiff["face_verification"] = {
      ...faceVerification.toJson(),
      'photo': photoUrl,
      'updated_at': FieldValue.serverTimestamp(),
    };

    _dynCoreProfile?.update(photoVerificationUrl: photoUrl);
  }

  void _handleSaveProfileError(Object e, void Function(String) showSnackbar) {
    if (e is FirebaseException) {
      handleFirebaseError(e, showSnackbar);
    } else {
      showSnackbar(e is FailedUploadException
          ? (e as dynamic).title
          : AppStrings.errorUnknown);
      log(e.toString());
    }
  }
}

import 'dart:async';
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
import 'package:whossy_app/feature/auth/onboarding/model/verification_challenge.dart';
import 'package:whossy_app/feature/home/edit_profile/data/repository/edit_profile_repository.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';

import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../../auth/onboarding/model/preferences.dart';
import '../../../../auth/sign_up/data/repository/user_repository.dart';
import '../../../../auth/sign_up/model/app_user.dart';
import '../../../../auth/sign_up/model/geography.dart';
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
    }
  }

  // The challenge shown for the verification photo currently sitting in
  // `_dynCoreProfile.faceVerification.photo` (a local file path, not yet
  // uploaded) — set by the photo-verification flow, consumed and cleared by
  // `_processFaceVerification` on save.
  VerificationChallenge? _pendingVerificationChallenge;

  set pendingVerificationChallenge(VerificationChallenge? value) {
    _pendingVerificationChallenge = value;
  }

  StreamSubscription<FaceVerification?>? _faceVerificationSub;
  bool _hasSeenFirstFaceVerificationSnapshot = false;

  /// Watches `users/{uid}.face_verification` so the app reflects an admin's
  /// approve/reject verdict (set via the Retool admin tooling) without
  /// requiring a manual refresh. Fires [onRejected] only on a genuine
  /// transition into 'rejected' observed during this subscription — not on
  /// the initial snapshot, so re-opening the app doesn't re-prompt for an
  /// already-known rejection.
  void listenToFaceVerificationStatus({
    required void Function(String message) onRejected,
  }) {
    _faceVerificationSub?.cancel();
    _hasSeenFirstFaceVerificationSnapshot = false;

    _faceVerificationSub =
        _userRepository.faceVerificationStream().listen((faceVerification) {
      final previousStatus = _dynCoreProfile?.faceVerification?.status;
      final isFirstSnapshot = !_hasSeenFirstFaceVerificationSnapshot;
      _hasSeenFirstFaceVerificationSnapshot = true;

      // Assign independent instances to the dynamic and static profiles.
      // Sharing a single instance here silently breaks `saveUserProfile`'s
      // diff: when the user takes a new selfie, `update()` mutates
      // `_dynCoreProfile.faceVerification.photo` in place — which would also
      // mutate the static baseline, so `diff()` sees no change (identical
      // instance) and the new photo is never uploaded or persisted.
      _dynCoreProfile?.faceVerification = faceVerification;
      _staticCoreProfile?.faceVerification = faceVerification == null
          ? null
          : FaceVerification.fromJson(faceVerification.toJson());

      if (!isFirstSnapshot &&
          previousStatus != 'rejected' &&
          faceVerification?.status == 'rejected') {
        onRejected(AppStrings.faceVerificationRejected);
      }

      notifyListeners();
    });
  }

  void cancelFaceVerificationListener() {
    _faceVerificationSub?.cancel();
    _faceVerificationSub = null;
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

  bool get isChangingPhotos {
    final diff = _dynCoreProfile?.diff(_staticCoreProfile!) ?? {};
    return diff.containsKey('photos');
  }

  // A4: what saving right now would do to verification — the pending edit
  // changes the main photo specifically, and there's a live approved badge
  // or in-flight review that the change would invalidate. Lets the save
  // button confirm before it happens, with copy matched to which case it is.
  MainPhotoChangeConsequence get pendingMainPhotoChangeConsequence {
    if (!isChangingPhotos) return MainPhotoChangeConsequence.none;

    final oldMain = _staticCoreProfile?.profilePics?.isNotEmpty == true
        ? _staticCoreProfile!.profilePics!.first
        : null;
    final newMain = _dynCoreProfile?.profilePics?.isNotEmpty == true
        ? _dynCoreProfile!.profilePics!.first
        : null;
    if (newMain == oldMain) return MainPhotoChangeConsequence.none;

    switch (_staticCoreProfile?.faceVerification?.getVerificationStatus()) {
      case FaceVerificationStatus.complete:
        return MainPhotoChangeConsequence.revokesApproval;
      case FaceVerificationStatus.pending:
        return MainPhotoChangeConsequence.cancelsPendingReview;
      default:
        return MainPhotoChangeConsequence.none;
    }
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
    } catch (e, s) {
      showSnackbar(AppStrings.errorUnknown);
      log('getUserData failed', name: 'EditProfile', error: e, stackTrace: s);
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

      // log('Core Prefs Diff: ${jsonEncode(corePrefsDiff)}');
      // log('Core Profile Diff: ${jsonEncode(coreProfileDiff)}');

      if (corePrefsDiff.isEmpty && coreProfileDiff.isEmpty) return true;

      // Process profile photos if available (may add is_approved/
      // face_verification to the diff itself — see _processProfilePhotos)
      await _processProfilePhotos(coreProfileDiff, showSnackbar);

      // Process face verification if available
      await _processFaceVerification(coreProfileDiff);

      await _editProfileRepo.updateProfileData(
        corePrefData: {...corePrefsDiff},
        coreProfileData: {...coreProfileDiff},
        updateUserDeletePic: _didUserDeletePic,
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
    List<String>? interests,
    List<String>? profilePics,
    List<String>? blockedIds,
    String? photoVerificationUrl,
    String? currentPlan,
    String? purchaseToken,
    PaymentPlatform? paymentPlatform,
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
      photoVerificationUrl: photoVerificationUrl,
      currentPlan: currentPlan,
      purchaseToken: purchaseToken,
      paymentPlatform: paymentPlatform,
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

  Future<void> _processProfilePhotos(
    Map<String, dynamic> coreProfileDiff,
    void Function(String) showSnackbar,
  ) async {
    if (coreProfileDiff["photos"] is! List<String>) return;

    final oldMainPhoto = _staticCoreProfile?.profilePics?.isNotEmpty == true
        ? _staticCoreProfile!.profilePics!.first
        : null;

    final updatedPhotos = await FileService().processPhotos(
      coreProfileDiff["photos"],
      showSnackbar,
    );

    coreProfileDiff["photos"] = updatedPhotos.photos;
    _dynCoreProfile?.update(profilePics: updatedPhotos.photos);

    final newMainPhoto =
        updatedPhotos.photos.isNotEmpty ? updatedPhotos.photos.first : null;

    // A4: only an actual main-photo change touches verification at all —
    // adding/removing/reordering any other photo doesn't.
    if (newMainPhoto != oldMainPhoto) {
      switch (_staticCoreProfile?.faceVerification?.getVerificationStatus()) {
        case FaceVerificationStatus.complete:
          // Revoke: there's a badge, and it was approved against the photo
          // that's about to change.
          coreProfileDiff['is_approved'] = false;
          final currentFv = _staticCoreProfile?.faceVerification;
          coreProfileDiff['face_verification'] = {
            if (currentFv != null) ...currentFv.toJson(),
            'status': 'revoked',
          };
          break;
        case FaceVerificationStatus.pending:
          // Cancel: no badge exists yet, so there's nothing to revoke, but
          // the pending submission was captured against the old photo and
          // is no longer trustworthy. Left alone, a reviewer approving it
          // later would hit the server's own stale-photo backstop
          // (functions/src/verification.ts) and land on `revoked` — correct
          // behavior for that backstop, but confusing copy for someone who
          // was never actually approved. Clearing it back to
          // never-submitted here avoids ever reaching that state and
          // re-surfaces the normal "verify your photo" prompt instead.
          //
          // Skipped if a fresh selfie is already staged in this same save
          // (e.g. a retake whose own auto-save previously failed) — that
          // submission should supersede the stale one below in
          // _processFaceVerification, not be discarded by it.
          final stagedSelfie = _dynCoreProfile?.faceVerification?.photo;
          final hasFreshSelfieStaged =
              stagedSelfie != null && !stagedSelfie.isUrl;
          if (!hasFreshSelfieStaged) {
            _dynCoreProfile?.faceVerification = null;
            coreProfileDiff['face_verification'] = null;
          }
          break;
        default:
          break;
      }
    }
  }

  Future<void> _processFaceVerification(
    Map<String, dynamic> coreProfileDiff,
  ) async {
    // `diff()` already serialized this to a Map via `faceVerification.toJson()`
    // — it is never a `FaceVerification` instance.
    if (coreProfileDiff["face_verification"] is! Map) return;

    final localPhoto = _dynCoreProfile?.faceVerification?.photo;

    // Nothing to upload — either no photo, or it's already a Storage URL
    // (e.g. only `status`/other fields changed).
    if (localPhoto == null || localPhoto.isUrl) return;

    final photoUrls = await _userRepository.uploadPictures(
      timeout: 30,
      files: [File(localPhoto)],
      pathGenerator: AppStrings.faceVerPicPath,
    );

    final photoUrl = photoUrls.isNotEmpty ? photoUrls.first : null;
    if (photoUrl == null) return;
    final challenge = _pendingVerificationChallenge;
    final mainPhoto = _dynCoreProfile?.profilePics?.isNotEmpty == true
        ? _dynCoreProfile!.profilePics!.first
        : null;

    coreProfileDiff["face_verification"] = FaceVerification.submission(
      photo: photoUrl,
      challengeId: challenge?.id,
      challengeImageUrl: challenge?.imageUrl,
      mainPhoto: mainPhoto,
    ).toJson()
      ..['updated_at'] = FieldValue.serverTimestamp();

    _dynCoreProfile?.update(photoVerificationUrl: photoUrl);
    _pendingVerificationChallenge = null;
  }

  void _handleSaveProfileError(Object e, void Function(String) showSnackbar) {
    if (e is FirebaseException) {
      handleFirebaseError(e, showSnackbar);
    } else {
      showSnackbar(
          e is FailedUploadException ? (e).message : AppStrings.errorUnknown);
      log(e.toString());
    }
  }

  Future<bool> addCreditsAfterPurchase({
    required int credits,
    void Function(String message)? onSnackbar,
    required double amount,
    required String currency,
  }) async {
    final previousCredit = coreProfile?.creditBalance ?? 0;

    updateProfile(
      creditBalance: previousCredit + credits,
    );

    final success = await saveUserProfile(
      showSnackbar: (msg) {},
    );

    if (!success) {
      updateProfile(
        creditBalance: previousCredit,
      );
      onSnackbar?.call(AppStrings.addCreditsFailure);
      return false;
    }

    onSnackbar?.call('Payment completed successfully!');
    return true;
  }

  Future<bool> updateSubscription({
    required String planId,
    required String purchaseToken,
  }) async {
    final isPremiumUser = coreProfile?.isPremium ?? false;
    final currentPlan = coreProfile?.currentPlan;
    final paymentPlatform = coreProfile?.paymentPlatform;

    updateProfile(
      isPremium: true,
      currentPlan: planId,
      purchaseToken: purchaseToken,
      paymentPlatform: PaymentPlatform.mobile,
    );

    final success = await saveUserProfile(showSnackbar: (msg) {});

    if (!success) {
      updateProfile(
        isPremium: isPremiumUser,
        currentPlan: currentPlan,
        paymentPlatform: paymentPlatform,
      );
    }

    return success;
  }

  void reset() {
    _dynCoreProfile = null;
    _staticCoreProfile = null;
    _dynCorePrefs = null;
    _staticCorePrefs = null;
    _hasSafetyGuideOpened = true;
    _didUserDeletePic = false;
    _pendingVerificationChallenge = null;
    cancelFaceVerificationListener();

    notifyListeners();
  }
}

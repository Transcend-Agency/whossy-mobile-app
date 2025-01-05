import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/common/components/Snackbar/app_snackbar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/feature/home/home_wrapper.dart';
import 'package:whossy_app/feature/home/preferences/model/other_preferences.dart';

import '../../../../../../common/utils/services/services.dart';
import '../../../../../../constants/index.dart';
import '../../../../edit_profile/model/core_profile.dart';
import '../../../../preferences/model/core_preferences.dart';
import '../../../_.dart';
import '../../../likes_and_match/data/repository/likes_repository.dart';
import '../../model/user_profile.dart';
import '../repository/match_repository.dart';

class SwipeAndMatchNotifier with ChangeNotifier {
  final _profileController = StreamController<List<UserProfile>>.broadcast();
  StreamSubscription? _profileSubscription;
  Stream<List<UserProfile>> get profileStream => _profileController.stream;

  final _matchRepository = MatchRepository();
  final _likesRepository = LikesRepository();
  final _sharedPrefs = SharedPrefsService();

  bool _hasDeniedLocationPermission = false;
  bool _hasTakenTutorial = false;

  CoreProfile? _profileData;

  // Used in filtering
  CorePreferences? _corePreferences;
  OtherPreferences? _otherPreferences;

  bool _hasFetchedProfiles = false;

  void saveFilters(CorePreferences? corePrefs, OtherPreferences? otherPrefs) {
    if (_otherPreferences == otherPrefs && _corePreferences == corePrefs) {
      return;
    }

    _otherPreferences = otherPrefs;
    _corePreferences = corePrefs;
    notifyListeners();

    log('Other Preferences \n ${otherPrefs.toString()}');

    fetchProfiles();
  }

  void saveProfile(CoreProfile? data) {
    if (_profileData == data) return;
    _profileData = data;
    notifyListeners();

    log('User Data \n ${data.toString()}');

    if (_profileData != null && !_hasFetchedProfiles) {
      fetchProfiles();
      _hasFetchedProfiles = true;
    }
  }

  bool get hasDeniedLocationPermission => _hasDeniedLocationPermission;

  bool get hasTakenTutorial => _hasTakenTutorial;

  set hasDeniedLocationPermission(bool value) {
    if (_hasDeniedLocationPermission != value) {
      _hasDeniedLocationPermission = value;
      notifyListeners();
    }
  }

  set hasTakenTutorial(bool value) {
    if (_hasTakenTutorial != value) {
      _hasTakenTutorial = value;
      notifyListeners();
    }
  }

  checkLocationPermissionState() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    hasDeniedLocationPermission =
        !await _sharedPrefs.isFirstTimeOpened(Matching.locationPermission, uid);
  }

  checkTutorialTakenState() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    hasTakenTutorial =
        !await _sharedPrefs.isFirstTimeOpened(HomeWrapper.tutorial, uid);
  }

  // Fetch profiles using Stream
  void fetchProfiles() {
    if (_profileData == null) {
      log('Profile data is still null, not fetching profiles');
      return;
    }

    try {
      _profileSubscription?.cancel();

      _profileSubscription = _matchRepository
          .fetchProfilesStream(
        blockedIds: _profileData?.blockedIds ?? [],
        longitude: _profileData?.longitude,
        latitude: _profileData?.latitude,
        preferences: _otherPreferences,
        corePreferences: _corePreferences,
        interests: _profileData?.interests ?? [],
      )
          .listen((fetchedProfiles) {
        _profileController.add(fetchedProfiles);

        notifyListeners();
      }, onError: (error) {
        log('Error fetching profiles: $error');
        _profileController.addError(error);
      }, onDone: () {
        log("Stream of profiles completed.");
      });
    } catch (e) {
      log('Error setting up profile stream: $e');
      _profileController.addError(e);
    }
  }

  Future<void> addLike(
    String likedId,
    String name, {
    bool addAction = true,
    required void Function(String, {SnackbarType type}) showSnackbar,
  }) async {
    try {
      String value = await _likesRepository.addLike(
        likedId: likedId,
        likerId: FirebaseAuth.instance.currentUser!.uid,
      );

      if (value == "match") {
        showSnackbar(
          'You have matched with $name!',
          type: SnackbarType.success,
        );
      }

      // Refresh profiles after action
      fetchProfiles();
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      log('An error occurred when trying to like a profile');
      showSnackbar(AppStrings.errorUnknown);
    }
  }

  Future<void> addDislike(
    String dislikedId, {
    bool addAction = true,
    required void Function(String) showSnackbar,
  }) async {
    try {
      await _likesRepository.addDislike(
        dislikedId: dislikedId,
        dislikerId: FirebaseAuth.instance.currentUser!.uid,
      );

      // Refresh profiles after action
      fetchProfiles();
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      log('An error occurred when trying to dislike a profile');
      showSnackbar(AppStrings.errorUnknown);
    }
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    _profileController.close();
    super.dispose();
  }
}

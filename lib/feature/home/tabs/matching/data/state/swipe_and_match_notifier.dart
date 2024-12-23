import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/utils/services/services.dart';
import '../../../../../../constants/index.dart';
import '../../../../edit_profile/model/core_profile.dart';
import '../../../_.dart';
import '../../../likes_and_match/data/repository/likes_repository.dart';
import '../../model/user_profile.dart';
import '../repository/match_repository.dart';

class SwipeAndMatchNotifier with ChangeNotifier {
  final _profileController = StreamController<List<UserProfile>>.broadcast();
  StreamSubscription? _profileSubscription;
  List<UserProfile> _profiles = [];

  Stream<List<UserProfile>> get profileStream => _profileController.stream;

  final _matchRepository = MatchRepository();
  final _likesRepository = LikesRepository();
  final _sharedPrefs = SharedPrefsService();

  List<Map<String, dynamic>> actionList = [];

  bool _hasDeniedLocationPermission = false;

  CoreProfile? _profileData;

  bool _hasFetchedProfiles = false;
  List<UserProfile> get profiles => _profiles;

  void saveProfile(CoreProfile? data) {
    _profileData = data;
    notifyListeners();

    log('User Data \n ${data.toString()}');

    if (_profileData != null && !_hasFetchedProfiles) {
      fetchProfiles();
      _hasFetchedProfiles = true;
    }
  }

  bool get hasDeniedLocationPermission => _hasDeniedLocationPermission;

  set hasDeniedLocationPermission(bool value) {
    if (_hasDeniedLocationPermission != value) {
      _hasDeniedLocationPermission = value;
      notifyListeners();
    }
  }

  checkLocationPermissionState() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    hasDeniedLocationPermission =
        !await _sharedPrefs.isFirstTimeOpened(Matching.name, uid);
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
      )
          .listen((fetchedProfiles) {
        if (fetchedProfiles.isNotEmpty) {
          _profiles = fetchedProfiles;
          _profileController.add(_profiles);
        }
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
    String likedId, {
    bool addAction = true,
    required void Function(String) showSnackbar,
  }) async {
    try {
      final uid = await _likesRepository.addLike(
        likedId: likedId,
        likerId: FirebaseAuth.instance.currentUser!.uid,
      );

      if (addAction) {
        actionList.add({
          'uid': uid,
          'collection': 'likes',
        });
      }
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      log('An error occurred when trying to like a profile');
      showSnackbar(AppStrings.errorUnknown);
    }
  }

  // Add a dislike
  Future<void> addDislike(
    String dislikedId, {
    bool addAction = true,
    required void Function(String) showSnackbar,
  }) async {
    try {
      final uid = await _likesRepository.addDislike(
        dislikedId: dislikedId,
        dislikerId: FirebaseAuth.instance.currentUser!.uid,
      );

      if (addAction) {
        actionList.add({
          'uid': uid,
          'collection': 'dislikes',
        });
      }
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      log('An error occurred when trying to dislike a profile');
      showSnackbar(AppStrings.errorUnknown);
    }
  }

  void undoLastAction({
    required void Function(String) showSnackbar,
  }) {
    try {
      if (actionList.isNotEmpty) {
        var lastAction = actionList.removeLast();
        _likesRepository.undoAction(action: lastAction);
      } else {
        log("No actions to undo.");
      }
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      log('An error occurred when trying to undo a last action');
      showSnackbar(AppStrings.errorUnknown);
    }
  }

  @override
  void dispose() {
    _profileSubscription?.cancel(); // Clean up subscription
    _profileController.close();
    super.dispose();
  }
}

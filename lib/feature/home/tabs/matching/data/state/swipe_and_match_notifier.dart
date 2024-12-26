import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/feature/home/home_wrapper.dart';

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

  // Maintain a set of excluded IDs
  final Set<String> _excludedIds = {};

  Stream<List<UserProfile>> get profileStream => _profileController.stream;

  final _matchRepository = MatchRepository();
  final _likesRepository = LikesRepository();
  final _sharedPrefs = SharedPrefsService();

  List<Map<String, dynamic>> actionList = [];

  bool _hasDeniedLocationPermission = false;
  bool _hasTakenTutoral = false;

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

  bool get hasTakenTutorial => _hasTakenTutoral;

  set hasDeniedLocationPermission(bool value) {
    if (_hasDeniedLocationPermission != value) {
      _hasDeniedLocationPermission = value;
      notifyListeners();
    }
  }

  set hasTakenTutorial(bool value) {
    if (_hasTakenTutoral != value) {
      _hasTakenTutoral = value;
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
      )
          .listen((fetchedProfiles) {
        // Filter out excluded profiles (liked/disliked)
        final filteredProfiles = fetchedProfiles
            .where((profile) => !_excludedIds.contains(profile.user.uid))
            .toList();

        if (filteredProfiles.isNotEmpty) {
          _profiles = filteredProfiles;
          _profileController.add(_profiles);
        } else {
          _profileController.add([]);
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

      // Add to excluded IDs
      _excludedIds.add(likedId);

      if (addAction) {
        actionList.add({
          'uid': uid,
          'collection': 'likes',
        });
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
      final uid = await _likesRepository.addDislike(
        dislikedId: dislikedId,
        dislikerId: FirebaseAuth.instance.currentUser!.uid,
      );

      // Add to excluded IDs
      _excludedIds.add(dislikedId);

      if (addAction) {
        actionList.add({
          'uid': uid,
          'collection': 'dislikes',
        });
      }

      // Refresh profiles after action
      fetchProfiles();
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

        // Remove from excluded IDs
        _excludedIds.remove(lastAction['uid']);

        // Refresh profiles after undo
        fetchProfiles();
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

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/feature/home/tabs/likes_and_match/data/repository/likes_repository.dart';

import '../../../../../../common/utils/services/services.dart';
import '../../../../../../constants/index.dart';
import '../../../../edit_profile/model/core_profile.dart';
import '../../../_.dart';
import '../../model/user_profile.dart';
import '../repository/match_repository.dart';

class SwipeAndMatchNotifier with ChangeNotifier {
  final _matchRepository = MatchRepository();
  final _likesRepository = LikesRepository();
  final _sharedPrefs = SharedPrefsService();

  List<UserProfile> _profiles = [];
  List<Map<String, dynamic>> actionList = [];

  bool _isLoading = false;
  bool _hasDeniedLocationPermission = false;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _hasMoreProfiles = true;
  DocumentSnapshot? _lastDoc;

  CoreProfile? _profileData;

  // Getters
  List<UserProfile> get profiles => _profiles;
  bool get isLoading => _isLoading;
  bool get hasMoreProfiles => _hasMoreProfiles;

  void saveProfile(CoreProfile? data) {
    _profileData = data;

    notifyListeners();

    log('Profile Data ${data.toString()}');
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

  // Fetch initial profiles
  Future<void> fetchInitialProfiles({
    int limit = 20,
  }) async {
    isLoading = true;

    try {
      final result = await _matchRepository.fetchProfiles(
        limit: limit,
        blockedIds: _profileData?.blockedIds ?? [],
        longitude: _profileData?.longitude,
        latitude: _profileData?.latitude,
      );

      final fetchedProfiles = result['profiles'] as List<UserProfile>;
      _lastDoc = result['lastDoc'] as DocumentSnapshot?;

      if (fetchedProfiles.isNotEmpty) {
        _profiles = fetchedProfiles;
      } else {
        _hasMoreProfiles = false;
      }
    } catch (e) {
      log('Error fetching profiles: $e');
    } finally {
      isLoading = false;
    }
  }

  // Load more profiles for pagination
  Future<void> fetchMoreProfiles({int limit = 10}) async {
    if (_isLoading || !_hasMoreProfiles) return;
    isLoading = true;

    try {
      final result = await _matchRepository.fetchProfiles(
        limit: limit,
        blockedIds: _profileData?.blockedIds ?? [],
        longitude: _profileData?.longitude,
        latitude: _profileData?.latitude,
        lastDoc: _lastDoc,
      );

      final fetchedProfiles = result['profiles'] as List<UserProfile>;
      _lastDoc = result['lastDoc'] as DocumentSnapshot?;

      if (fetchedProfiles.isNotEmpty) {
        _profiles.addAll(fetchedProfiles);
      } else {
        _hasMoreProfiles = false;
      }
    } catch (e) {
      log('Error fetching more profiles: $e');
    } finally {
      isLoading = false;
    }
  }

  // Refresh profiles by resetting state
  Future<void> refreshProfiles() async {
    _profiles.clear();
    _lastDoc = null;
    _hasMoreProfiles = true;
    await fetchInitialProfiles();
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
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/feature/home/tabs/likes_and_match/data/repository/likes_repository.dart';

import '../../../../../../constants/index.dart';
import '../../model/user_profile.dart';
import '../repository/match_repository.dart';

class MatchNotifier with ChangeNotifier {
  final _matchRepository = MatchRepository();
  final _likesRepository = LikesRepository();

  List<UserProfile> _profiles = [];

  bool _isLoading = false;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _hasMoreProfiles = true;
  DocumentSnapshot? _lastDoc;

  // Getters
  List<UserProfile> get profiles => _profiles;
  bool get isLoading => _isLoading;
  bool get hasMoreProfiles => _hasMoreProfiles;

  // Fetch initial profiles
  Future<void> fetchInitialProfiles({int limit = 10}) async {
    isLoading = true;

    try {
      final result = await _matchRepository.fetchProfiles(limit: limit);
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
    required void Function(String) showSnackbar,
  }) async {
    try {
      await _likesRepository.addLike(
        likedId: likedId,
        likerId: FirebaseAuth.instance.currentUser!.uid,
      );
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      log('An error occurred when trying to like a profile');
      showSnackbar(AppStrings.errorUnknown);
    }
  }

  // Delete a like (undo)
  Future<void> deleteLike(
    String likedId, {
    required void Function(String) showSnackbar,
  }) async {
    try {
      await _likesRepository.removeLike(
        likedId: likedId,
        likerId: FirebaseAuth.instance.currentUser!.uid,
      );
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      log('An error occurred when trying to unlike a profile');
      showSnackbar(AppStrings.errorUnknown);
    }
  }
}

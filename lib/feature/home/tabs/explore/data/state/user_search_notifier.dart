import 'dart:async';
import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import '../../model/liked_user_profile.dart';
import '../../model/user_search_result.dart';
import '../repository/user_search_repository.dart';

enum UserSearchStatus { idle, tooShort, loading, done, error }

/// State for the name search box on Explore. Waits for a pause in typing,
/// then asks the server; a response that arrives after the term has changed
/// again is dropped, so results never flash back to an older query.
class UserSearchNotifier extends ChangeNotifier {
  UserSearchNotifier({UserSearchRepository? repository, Duration? debounce})
      : _repository = repository ?? UserSearchRepository(),
        _debounce = debounce ?? const Duration(milliseconds: 350);

  final UserSearchRepository _repository;
  final Duration _debounce;

  String _term = '';
  UserSearchStatus _status = UserSearchStatus.idle;
  List<UserSearchResult> _results = const [];
  String? _error;
  Timer? _timer;
  int _request = 0;
  bool _disposed = false;

  String get term => _term;
  UserSearchStatus get status => _status;
  List<UserSearchResult> get results => _results;
  String? get error => _error;

  /// Whether the Explore grid should give way to search results.
  bool get isSearching => _term.trim().isNotEmpty;

  void updateTerm(String value) {
    _term = value;
    _timer?.cancel();
    final request = ++_request;
    final trimmed = value.trim();

    _results = const [];
    _error = null;
    if (trimmed.isEmpty) {
      _status = UserSearchStatus.idle;
    } else if (!isSearchable(trimmed)) {
      _status = UserSearchStatus.tooShort;
    } else {
      _status = UserSearchStatus.loading;
      _timer = Timer(_debounce, () => _run(trimmed, request));
    }
    _notify();
  }

  void clear() => updateTerm('');

  Future<void> _run(String query, int request) async {
    try {
      final results = await _repository.search(query);
      if (request != _request) return;
      _results = results;
      _status = UserSearchStatus.done;
    } catch (e) {
      if (request != _request) return;
      log('searchUsers failed: $e');
      _results = const [];
      _error = _messageFor(e);
      _status = UserSearchStatus.error;
    }
    _notify();
  }

  Future<LikedUserProfile?> openProfile(String uid) => _repository.openProfile(uid);

  static const _serverMessageCodes = {
    'resource-exhausted',
    'invalid-argument',
    'failed-precondition',
    'permission-denied',
  };

  String _messageFor(Object e) {
    if (e is FirebaseFunctionsException &&
        _serverMessageCodes.contains(e.code) &&
        (e.message?.isNotEmpty ?? false)) {
      return e.message!;
    }
    return "Couldn't search right now. Please try again.";
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}

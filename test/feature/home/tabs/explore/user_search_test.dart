import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/feature/home/tabs/explore/data/repository/user_search_repository.dart';
import 'package:whossy_app/feature/home/tabs/explore/data/state/user_search_notifier.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/liked_user_profile.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/user_search_result.dart';

class _FakeRepository implements UserSearchRepository {
  final calls = <String>[];
  final pending = <String, Completer<List<UserSearchResult>>>{};

  @override
  Future<List<UserSearchResult>> search(String query) {
    calls.add(query);
    return (pending[query] = Completer<List<UserSearchResult>>()).future;
  }

  @override
  Future<LikedUserProfile?> openProfile(String uid) async => null;
}

UserSearchResult _person(String uid, String name) =>
    UserSearchResult(uid: uid, firstName: name, age: 30);

void main() {
  group('isSearchable', () {
    test('needs a word of at least two letters', () {
      expect(isSearchable('a'), isFalse);
      expect(isSearchable('a b'), isFalse);
      expect(isSearchable('ad'), isTrue);
      expect(isSearchable('a obi'), isTrue);
    });

    test('ignores punctuation and counts an accented letter once', () {
      expect(isSearchable(" - ' "), isFalse);
      expect(isSearchable('é'), isFalse);
      expect(isSearchable('é'), isFalse);
      expect(isSearchable('ém'), isTrue);
    });
  });

  test('parses a searchUsers result, tolerating a missing age and photo', () {
    final r = UserSearchResult.fromJson({'uid': 'u1', 'first_name': 'Ada', 'age': null, 'photo': null});
    expect(r.uid, 'u1');
    expect(r.firstName, 'Ada');
    expect(r.age, isNull);
    expect(r.photo, isNull);
  });

  group('UserSearchNotifier', () {
    late _FakeRepository repo;
    late UserSearchNotifier search;

    setUp(() {
      repo = _FakeRepository();
      search = UserSearchNotifier(repository: repo, debounce: const Duration(milliseconds: 20));
    });
    tearDown(() => search.dispose());

    test('a one-letter term shows the hint and never calls the server', () async {
      search.updateTerm('a');
      expect(search.status, UserSearchStatus.tooShort);
      expect(search.isSearching, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(repo.calls, isEmpty);
    });

    test('waits for a pause in typing and searches only the last term', () async {
      search.updateTerm('ad');
      search.updateTerm('ada');
      expect(search.status, UserSearchStatus.loading);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(repo.calls, ['ada']);

      repo.pending['ada']!.complete([_person('u1', 'Ada')]);
      await Future<void>.delayed(Duration.zero);
      expect(search.status, UserSearchStatus.done);
      expect(search.results.single.uid, 'u1');
    });

    test('a slow answer to an older term is dropped', () async {
      search.updateTerm('ada');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      search.updateTerm('tunde');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      repo.pending['tunde']!.complete([_person('u2', 'Tunde')]);
      await Future<void>.delayed(Duration.zero);
      repo.pending['ada']!.complete([_person('u1', 'Ada')]);
      await Future<void>.delayed(Duration.zero);

      expect(search.results.map((r) => r.uid), ['u2']);
    });

    test('clearing returns to the Explore grid', () async {
      search.updateTerm('ada');
      search.clear();
      expect(search.isSearching, isFalse);
      expect(search.status, UserSearchStatus.idle);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(repo.calls, isEmpty);
    });

    test('a failed search shows a generic message', () async {
      search.updateTerm('ada');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      repo.pending['ada']!.completeError(Exception('offline'));
      await Future<void>.delayed(Duration.zero);
      expect(search.status, UserSearchStatus.error);
      expect(search.error, "Couldn't search right now. Please try again.");
    });
  });
}

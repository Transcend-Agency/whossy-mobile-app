import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/feature/home/tabs/likes_and_match/data/repository/likes_repository.dart';

void main() {
  late FakeFirebaseFirestore db;
  late LikesRepository repo;
  final original = Timestamp.fromDate(DateTime.utc(2026, 11, 26, 15, 14));

  setUp(() {
    db = FakeFirebaseFirestore();
    repo = LikesRepository(firestore: db);
  });

  Future<void> seedLike(String liker, String liked) =>
      db.doc('likes/${liker}_$liked').set({
        'liker_id': liker,
        'liked_id': liked,
        'uid': '${liker}_$liked',
        'timestamp': original,
      });

  test('liking someone who liked me writes my like and reports a match',
      () async {
    await seedLike('amadi', 'ola');

    expect(await repo.addLike(likedId: 'amadi', likerId: 'ola'), 'match');
    expect((await db.doc('likes/ola_amadi').get()).exists, isTrue);
  });

  test('a first like with no like back reports a like', () async {
    expect(await repo.addLike(likedId: 'amadi', likerId: 'ola'), 'like');
    expect((await db.doc('likes/ola_amadi').get()).exists, isTrue);
  });

  test('liking again leaves the existing like untouched', () async {
    // The rules refuse any overwrite of a like, so a second write would
    // fail on a real device. Already matched: still reported as a match.
    await seedLike('amadi', 'ola');
    await seedLike('ola', 'amadi');

    expect(await repo.addLike(likedId: 'amadi', likerId: 'ola'), 'match');
    final mine = await db.doc('likes/ola_amadi').get();
    expect(mine.data()!['timestamp'], original);
  });

  test('liking again without a like back is still just a like', () async {
    await seedLike('ola', 'amadi');

    expect(await repo.addLike(likedId: 'amadi', likerId: 'ola'), 'like');
    expect((await db.doc('likes/ola_amadi').get()).data()!['timestamp'],
        original);
  });

  test('hasLiked reads only my own like', () async {
    await seedLike('amadi', 'ola');

    expect(await repo.hasLiked(likerId: 'ola', likedId: 'amadi'), isFalse);
    expect(await repo.hasLiked(likerId: 'amadi', likedId: 'ola'), isTrue);
  });
}

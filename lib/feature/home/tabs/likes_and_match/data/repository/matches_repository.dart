import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

class MatchesRepository {
  final _matches = FirebaseFirestore.instance.collection('matches');
  final _users = FirebaseFirestore.instance.collection('users');

  Stream<int> getMatchesCount() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _matches
        .where('user_ids', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<UserProfile>> getMatchesWithProfile() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Single query using array-contains
    return _matches
        .where('user_ids', arrayContains: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((matchesSnapshot) async {
      final otherUserIds = matchesSnapshot.docs
          .map((doc) {
            // Identify the "other user" by finding the ID that isn’t `userId`
            final user1Id = doc['user1_id'] as String;
            final user2Id = doc['user2_id'] as String;
            return user1Id == userId ? user2Id : user1Id;
          })
          .toSet()
          .toList();

      // Fetch the profiles in batches
      return _fetchUserProfilesInBatches(otherUserIds);
    });
  }

  Future<List<UserProfile>> _fetchUserProfilesInBatches(
    List<String> userIds,
  ) async {
    List<UserProfile> userProfiles = [];

    for (int i = 0; i < userIds.length; i += 10) {
      final batchIds =
          userIds.sublist(i, i + 10 > userIds.length ? userIds.length : i + 10);

      final userSnapshots =
          await _users.where(FieldPath.documentId, whereIn: batchIds).get();

      userProfiles.addAll(
        userSnapshots.docs.map(
          (doc) => UserProfile.fromJson(doc.data()),
        ),
      );
    }

    return userProfiles;
  }
}

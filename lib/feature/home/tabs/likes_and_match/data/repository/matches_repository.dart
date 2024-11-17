import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

class MatchesRepository {
  final _matches = FirebaseFirestore.instance.collection('matches');
  final _userRepository = UserRepository();

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

      // Use the helper function to fetch profiles in batches
      return await _userRepository.getUserProfilesInBatches(otherUserIds);
    });
  }
}

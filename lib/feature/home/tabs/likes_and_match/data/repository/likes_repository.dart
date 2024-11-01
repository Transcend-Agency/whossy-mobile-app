import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:whossy_app/common/utils/app_utils.dart';

class LikesRepository {
  final _likes = FirebaseFirestore.instance.collection('likes');

  Future<void> addLike({
    required String likedId,
    required String likerId,
  }) async {
    final uid = AppUtils.generateCombinedId(likerId, likedId);

    // Prepare the like data
    final likeData = {
      'liked_id': likedId,
      'liker_id': likerId,
      'timestamp': ServerValue.timestamp,
      'uid': uid,
    };

    // Add the like to Firestore
    await _likes.doc(uid).set(likeData);
  }

  Future<void> removeLike({
    required String likedId,
    required String likerId,
  }) async {
    final uid = AppUtils.generateCombinedId(likerId, likedId);

    // Remove the like from Firestore
    await _likes.doc(uid).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whossy_app/common/utils/app_utils.dart';

class LikesRepository {
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _dislikes = FirebaseFirestore.instance.collection('dislikes');

  Future<void> addLike({
    required String likedId,
    required String likerId,
  }) async {
    final uid = AppUtils.generateCombinedId(likerId, likedId);

    final likeData = {
      'liked_id': likedId,
      'liker_id': likerId,
      'timestamp': FieldValue.serverTimestamp(),
      'uid': uid,
    };

    await _likes.doc(uid).set(likeData);
  }

  Future<void> removeLike({
    required String likedId,
    required String likerId,
  }) async {
    final uid = AppUtils.generateCombinedId(likerId, likedId);
    await _likes.doc(uid).delete();
  }

  Future<void> addDislike({
    required String dislikedId,
    required String dislikerId,
  }) async {
    final uid = AppUtils.generateCombinedId(dislikerId, dislikedId);

    final dislikeData = {
      'disliked_id': dislikedId,
      'disliker_id': dislikerId,
      'timestamp': FieldValue.serverTimestamp(),
      'uid': uid,
    };

    await _dislikes.doc(uid).set(dislikeData);
  }

  Future<void> removeDislike({
    required String dislikedId,
    required String dislikerId,
  }) async {
    final uid = AppUtils.generateCombinedId(dislikerId, dislikedId);
    await _dislikes.doc(uid).delete();
  }
}

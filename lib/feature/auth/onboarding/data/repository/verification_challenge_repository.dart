import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/verification_challenge.dart';

class VerificationChallengeRepository {
  final _challenges = FirebaseFirestore.instance.collection(
    'Challenges',
  );

  /// Picks a random active challenge to show the user before they capture
  /// their verification selfie. Returns null if the pool is empty.
  Future<VerificationChallenge?> getRandomChallenge() async {
    final snapshot = await _challenges.where('active', isEqualTo: true).get();

    if (snapshot.docs.isEmpty) return null;

    final pick = snapshot.docs[Random().nextInt(snapshot.docs.length)];

    return VerificationChallenge.fromJson(pick.id, pick.data());
  }
}

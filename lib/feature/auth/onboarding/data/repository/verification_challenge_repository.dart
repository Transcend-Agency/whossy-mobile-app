import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/verification_challenge.dart';

class VerificationChallengeRepository {
  final _challenges = FirebaseFirestore.instance.collection(
    'Challenges',
  );


  Future<VerificationChallenge?> getRandomChallenge({String? excludeId}) async {
    final snapshot = await _challenges.where('active', isEqualTo: true).get();

    if (snapshot.docs.isEmpty) return null;

    var docs = snapshot.docs;
    if (excludeId != null && docs.length > 1) {
      docs = docs.where((d) => d.id != excludeId).toList();
    }

    final pick = docs[Random().nextInt(docs.length)];

    return VerificationChallenge.fromJson(pick.id, pick.data());
  }
}

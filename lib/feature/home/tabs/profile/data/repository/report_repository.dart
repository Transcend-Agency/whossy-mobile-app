import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/report.dart';

class ReportRepository {
  final _reportFirestore = FirebaseFirestore.instance.collection('userReports');

  Future<void> addReport(Report report) async {
    try {
      // Convert the Report instance to JSON and add it to Firestore
      await _reportFirestore
          .doc(report.id)
          .set(report.toJson(), SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }
}

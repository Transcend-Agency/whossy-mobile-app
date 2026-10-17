import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../../../../../constants/index.dart';
import '../../model/report.dart';
import '../repository/report_repository.dart';

class ReportNotifier extends ChangeNotifier {
  final _reportRepository = ReportRepository();

  Future<void> reportUser(
    Report report, {
    required void Function(String) showSnackbar,
  }) async {
    try {
      await _reportRepository.addReport(report);
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      log('An error occurred when trying to send a report');
      showSnackbar(AppStrings.errorUnknown);
    }
  }
}

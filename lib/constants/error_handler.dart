import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'strings.dart';

void handleFirebaseAuthError(
  FirebaseException e,
  void Function(String) showSnackbar,
) {
  log('The code is ${e.code}');
  switch (e.code) {
    case 'email-already-in-use':
      showSnackbar(AppStrings.errorEmailInUse);
      break;
    case 'invalid-email':
      showSnackbar(AppStrings.errorInvalidEmail);
      break;
    case 'user-disabled':
      showSnackbar(AppStrings.disabledAccount);
      break;
    case 'user-not-found':
      showSnackbar(AppStrings.userNotFound);
      break;
    case 'wrong-password' || 'invalid-credential':
      showSnackbar(AppStrings.userNotFound);
      break;
    case 'too-many-requests':
      showSnackbar(AppStrings.tooManyRequests);
      break;
    case 'operation-not-allowed':
      showSnackbar(AppStrings.errorOperationNotAllowed);
      break;
    case 'weak-password':
      showSnackbar(AppStrings.errorWeakPassword);
      break;
    case 'network-request-failed':
      showSnackbar(AppStrings.errorNetworkRequestFailed);
      break;
    default:
      showSnackbar(AppStrings.errorUnknown);
  }
}

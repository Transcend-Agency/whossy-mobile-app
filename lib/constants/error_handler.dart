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
    case 'invalid-verification-code':
      showSnackbar(AppStrings.errorInvalidCode);
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
    case 'account-exists-with-different-credential':
      showSnackbar(AppStrings.differentCredentials);
      break;
    default:
      showSnackbar(AppStrings.errorUnknown);
  }
}

void handleFirebaseError(
  FirebaseException e,
  void Function(String) showSnackbar,
) {
  log('The code is ${e.code}');
  switch (e.code) {
    case 'user-disabled':
      showSnackbar(AppStrings.disabledAccount);
      break;
    case 'user-not-found':
      showSnackbar(AppStrings.userNotFound);
      break;
    case 'too-many-requests':
      showSnackbar(AppStrings.tooManyRequests);
      break;
    case 'network-request-failed':
      showSnackbar(AppStrings.errorNetworkRequestFailed);
      break;
    case 'unavailable':
      showSnackbar(AppStrings.deviceOffline);
      break;
    default:
      showSnackbar(AppStrings.errorUnknown);
  }
}

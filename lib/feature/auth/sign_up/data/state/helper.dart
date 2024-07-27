// Error handler function
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../constants/index.dart';

void handleFirebaseAuthError(
  FirebaseException e,
  void Function(String) showSnackbar,
) {
  switch (e.code) {
    case 'email-already-in-use':
      showSnackbar(AppStrings.errorEmailInUse);
      break;
    case 'invalid-email':
      showSnackbar(AppStrings.errorInvalidEmail);
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

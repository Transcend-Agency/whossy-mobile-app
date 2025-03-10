import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../common/components/components.dart';
import '../../../../../common/utils/services/services.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../../auth/login/data/repository/authentication_repository.dart';
import '../../../../auth/sign_up/data/repository/user_repository.dart';
import '../../../edit_profile/view/widgets/sheets/name_sheet.dart';
import '../../../tabs/matching/model/user_profile.dart';
import '../../model/user_settings.dart';

class SettingsNotifier extends ChangeNotifier {
  final _settings = UserSettings();
  final _userService = UserPresenceService();
  final _userRepository = UserRepository();
  final _authRepository = AuthenticationRepository();

  UserSettings get settings => _settings;

  bool getValue(CoreSettings setting) {
    return _settings.getValue(setting) ?? false;
  }

  Future<List<UserProfile>> getBlockedUsers(List<String> userIds) {
    return _userRepository.getUserProfilesInBatches(
      userIds: userIds,
      blockedIds: [],
      settings: const ExcludeSettings(
        excludeIncompleteOnboarding: true,
        excludeBannedUsers: true,
        excludeUnapprovedUsers: false,
        excludeBlockedAndSelf: false,
      ),
    );
  }

  void updateSwitch(CoreSettings setting, bool newValue) {
    _settings.updateSwitch(setting, newValue);
    notifyListeners();
  }

  Future<void> signOut(void Function(String) showSnackbar) async {
    try {
      await _userService.updateUserStatus(false);
      await _userRepository.removeUserToken();
      await _userRepository.signOut();
    } catch (e) {
      log(e.toString());
      // showSnackbar(AppStrings.signOutFailure);
    }
    notifyListeners();
  }

  Future<bool?> deleteAccount(
    BuildContext context,
    void Function(String) showSnackbar,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showSnackbar(AppStrings.deleteAccountFailed);
        return false;
      }

      // Show confirmation dialog **inside** `deleteAccount`
      bool? confirmDelete = await showConfirmationDialog(
        context,
        title: "Delete Account?",
        content: contentText(AppStrings.deleteAccount),
        yes: 'Delete',
      );

      if (confirmDelete != true) return null; // User canceled

      final provider = _authRepository.getUserAuthProvider();
      if (provider == null) {
        showSnackbar(AppStrings.deleteAccountFailed);
        return false;
      }

      bool reAuth = false;

      // **Reauthentication Handling**
      if (provider == "password" && context.mounted) {
        String? password = await showNameSheet(
          context: context,
          name: '',
          title: "Enter Password",
        );

        if (password == null) return null; // User canceled password input
        reAuth = await _authRepository.reAuthenticateWithEmail(password);
      } else if (provider == "phone") {
        // reAuth = await _authRepository.reauthenticateWithPhone(user.phoneNumber!);
      } else if (provider == "google.com") {
        reAuth = await _authRepository.reAuthenticateWithGoogle();
      } else if (provider == "apple.com") {
        reAuth = await _authRepository.reAuthenticateWithApple();
      }

      if (!reAuth) {
        showSnackbar(AppStrings.failedReAuth);
        return false;
      }

      // **Delete User Data**
      await _userRepository.deleteUserData(user.uid);

      // **Delete Firebase User**
      await user.delete();

      // **Sign Out**
      await signOut(showSnackbar);

      return true; // Deletion successful
    } catch (e) {
      log("Delete Account Error: $e");
      showSnackbar("Failed to delete account. Please try again.");
      return false;
    }
  }
}

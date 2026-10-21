import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/utils/router/router.dart';
import '../../../common/utils/router/router.gr.dart';

/// Things that must be true before the home screen is usable.
///
///  - The installed build is one the server still supports. An old build
///    keeps making writes that newer security rules reject, and fails in
///    ways the user cannot make sense of. `config/app` holds the minimum
///    build number per platform; with no such document nobody is blocked.
///  - The profile has at least two photos. Accounts created before that was
///    enforced can be short; they are stopped here and sent to add them,
///    rather than left to discover it from failed actions.
class AccountGate extends StatefulWidget {
  const AccountGate({super.key, required this.child});

  final Widget child;

  static const minPhotos = 2;

  @override
  State<AccountGate> createState() => _AccountGateState();
}

class _AccountGateState extends State<AccountGate> {
  final _firestore = FirebaseFirestore.instance;
  int? _build;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _build = int.tryParse(info.buildNumber));
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return widget.child;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _firestore.collection('config').doc('app').snapshots(),
      builder: (context, config) {
        final store = _storeUpdateFor(config.data?.data());
        if (store != null) return store;

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _firestore.collection('users').doc(uid).snapshots(),
          builder: (context, user) {
            final data = user.data?.data();
            // Nothing is hidden until the profile has actually loaded.
            if (data == null) return widget.child;

            final photos = (data['photos'] as List?)?.length ?? 0;
            final onboarded = data['has_completed_onboarding'] == true;
            if (!onboarded || photos >= AccountGate.minPhotos) {
              return widget.child;
            }

            final missing = AccountGate.minPhotos - photos;
            return _Blocker(
              title: 'Add $missing more photo${missing == 1 ? '' : 's'}',
              body: 'Your profile needs at least ${AccountGate.minPhotos} '
                  'photos before you can browse, like or message.',
              action: 'Add photos',
              onAction: () => Nav.push(context, const EditProfile()),
            );
          },
        );
      },
    );
  }

  Widget? _storeUpdateFor(Map<String, dynamic>? config) {
    final build = _build;
    if (config == null || build == null) return null;

    final platform = Platform.isIOS ? 'ios' : 'android';
    final minBuild = (config['min_${platform}_build'] as num?)?.toInt() ?? 0;
    if (build >= minBuild) return null;

    final url = config['${platform}_store_url'] as String? ??
        (Platform.isAndroid
            ? 'https://play.google.com/store/apps/details?id=com.whossy.whossy_app'
            : null);

    return _Blocker(
      title: 'Update Whossy',
      body: 'This version is no longer supported. Update to keep using the '
          'app; your account and chats are unchanged.',
      action: url == null ? null : 'Update',
      onAction: url == null
          ? null
          : () => launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              ),
    );
  }
}

class _Blocker extends StatelessWidget {
  const _Blocker({
    required this.title,
    required this.body,
    this.action,
    this.onAction,
  });

  final String title;
  final String body;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                body,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              if (action != null) ...[
                const SizedBox(height: 32),
                FilledButton(onPressed: onAction, child: Text(action!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

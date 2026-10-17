import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/components/components.dart';
import '../../../../../common/styles/component_style.dart';
import '../../../../auth/onboarding/data/repository/verification_challenge_repository.dart';
import '../../../../auth/onboarding/model/verification_challenge.dart';
import '../../data/state/edit_profile_notifier.dart';
import 'tabs/take_selfie.dart';
import 'tabs/verify_photo.dart';

@RoutePage()
class PhotoVerification extends StatefulWidget {
  const PhotoVerification({super.key, this.photoUrl});

  final String? photoUrl;

  @override
  State<PhotoVerification> createState() => _PhotoVerificationState();
}

class _PhotoVerificationState extends State<PhotoVerification> {
  final _imagePickedNotifier = ValueNotifier(false);
  final _challengeRepository = VerificationChallengeRepository();
  late final PageController _pageController;
  late int _currentPage;
  File? _image;
  VerificationChallenge? _challenge;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.photoUrl != null ? 1 : 0;
    _pageController = PageController(initialPage: _currentPage);
    _loadChallenge();
  }

  // Always fetch a fresh random challenge when this flow is entered, so a
  // retake never reuses the pose the user just saw. [excludeId] backs the
  // in-flow "different pose" refresh.
  Future<void> _loadChallenge({String? excludeId}) async {
    final challenge =
        await _challengeRepository.getRandomChallenge(excludeId: excludeId);

    if (!mounted) return;

    setState(() => _challenge = challenge);
    context.read<EditProfileNotifier>().pendingVerificationChallenge =
        challenge;
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      Navigator.of(context).pop(_image); // Popping with the image data
    }
  }

  // This callback will be passed to TakeSelfie to capture the image
  void _onImagePicked(File? image) {
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: pagePadding,
      appBar: const CustomAppBar(
        addBarHeight: 4,
        title: 'Photo Verification',
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const VerifyPhoto(),
              TakeSelfie(
                photoUrl: widget.photoUrl,
                challenge: _challenge,
                onRefreshChallenge: () =>
                    _loadChallenge(excludeId: _challenge?.id),
                imagePickedNotifier: _imagePickedNotifier,
                onImagePicked: _onImagePicked, // Pass callback
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ValueListenableBuilder<bool>(
                valueListenable: _imagePickedNotifier,
                builder: (context, isImagePicked, child) {
                  return _currentPage == 0
                      ? AppButton(
                          onPress: _nextPage,
                          text: 'Continue',
                        )
                      : AppButton(
                          onPress: isImagePicked ? _nextPage : null,
                          text: 'Continue',
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _imagePickedNotifier.dispose();
    super.dispose();
  }
}

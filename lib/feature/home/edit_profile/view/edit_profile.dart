import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../../../../provider/providers.dart';
import '../../settings/view/widgets/_.dart';
import 'widgets/_.dart';

@RoutePage()
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with SingleTickerProviderStateMixin {
  late EditProfileNotifier _profileNotifier;
  late AnimationController _controller;
  bool _hasSave = false;
  late bool _meetsPicCount;

  set hasSave(bool newValue) {
    setState(() => _hasSave = newValue);
  }

  Future<void> wait() async =>
      await Future.delayed(const Duration(milliseconds: 200));

  @override
  void initState() {
    super.initState();

    // Using context.read to avoid listening for changes
    _profileNotifier = context.read<EditProfileNotifier>();

    _controller = BottomSheet.createAnimationController(this)
      ..duration = const Duration(milliseconds: 400)
      ..reverseDuration = const Duration(milliseconds: 400);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_profileNotifier.hasEditFetched) {
        _profileNotifier.getUserData(showSnackbar: showSnackbar);
      } else {
        _profileNotifier.hasEditFetched = true;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Accessing context.watch here is safe
    _meetsPicCount = context.watch<EditProfileNotifier>().picCount >= 3;
  }

  onSaveChanges() async {
    if (!_meetsPicCount) {
      return await onValidateSave();
    }

    // Show loading sheet and wait for it to display
    showLoadingSheet(
      context,
      _controller,
      header: 'Changes are saving 🎉',
      subHeader: 'Your changes will be saved in a minute',
    );

    // Save user profile and wait for it to complete
    await _profileNotifier.saveUserProfile(
      showSnackbar: (msg) => showSnackbar(msg, pop: true),
    );

    if (!mounted) return;

    // Dismiss the loading sheet before navigating
    Navigator.of(context).pop(); // Pop the loading sheet

    // Navigate to the HomeWrapper after the loading sheet is dismissed
    Nav.popUntil(context, HomeWrapper.name);
  }

  showSnackbar(String message, {bool pop = false}) {
    if (mounted) {
      if (pop) Navigator.of(context).pop();
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

  Future<void> onPopInvoked(bool didPop) async {
    if (!didPop && _hasSave) {
      bool? result = await showConfirmationDialog(
        yes: 'Continue',
        no: 'Save',
        headerImage: Image.asset(AppAssets.caution, height: 100),
        context,
        title: 'Caution',
        content: contentText(
            "You have unsaved changes. Are you sure you want to exit without saving?"),
      );

      if (result == null || !context.mounted) return;

      if (!result) {
        await wait();

        await onSaveChanges();
      }

      if (result) {
        if (mounted) {
          _profileNotifier.resetToStatic();
          Navigator.of(context).pop();
        }
      }
    }
  }

  onPreview() async {
    await showConfirmationDialog(
      context,
      title: 'Preview Unavailable',
      content: contentText(AppStrings.noProfilePic),
    );
  }

  onValidateSave() async {
    await showConfirmationDialog(
      context,
      title: "Incomplete Profile",
      content: contentText(AppStrings.minPicsRequired),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasSave,
      onPopInvoked: onPopInvoked,
      child: AppScaffold(
        useScrollView: true,
        appBar: CustomAppBar(
          addBarHeight: 4,
          title: 'Edit Profile',
          onPop: _hasSave ? () async => await onPopInvoked(false) : null,
          action: Selector<EditProfileNotifier, bool>(
            selector: (_, pref) => pref.hasChanges,
            builder: (_, save, __) {
              if (_hasSave != save) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  hasSave = save;
                });
              }
              return save
                  ? Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: TextButton(
                        onPressed: onSaveChanges,
                        child: Text(
                          'Save',
                          style: TextStyles.boldPrefText.copyWith(
                            color: AppColors.saveColor,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Selector<EditProfileNotifier, bool?>(
                  selector: (_, pref) => pref.picCount > 0,
                  builder: (_, hasPhotos, __) {
                    return ExtraCoreSettings(
                      onTap: () {
                        if (hasPhotos == true) {
                          Nav.push(context, const PreviewProfile());
                        } else {
                          onPreview();
                        }
                        return null;
                      },
                      customChildren: [
                        Text(
                          'Preview Profile',
                          style: TextStyles.prefText.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    );
                  },
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const MediaEditProfile(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const CoreEditProfileList(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const BioEditProfile(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const InterestsTile(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const ExtraEditProfileList(),
            ),
          ],
        ),
      ),
    );
  }
}

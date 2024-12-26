import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import 'widgets/_.dart';

// Define the typedef
typedef _Notifier = PreferencesNotifier;

@RoutePage()
class PreferenceScreen extends HookWidget {
  const PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<_Notifier>();
    final hasSave = useState<bool>(false);

    showSnackbar(String message, {bool pop = false}) {
      if (context.mounted) {
        if (pop) Navigator.of(context).pop();
        showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
      }
    }

    onSaveChanges({bool popAfterSave = true}) async {
      await notifier.saveFilters(
        showSnackbar: (msg) => showSnackbar(msg, pop: true),
      );

      if (!context.mounted) return;

      if (popAfterSave) Navigator.of(context).pop();
    }

    Future<void> onPopInvoked(bool didPop) async {
      if (!didPop && hasSave.value) {
        bool? result = await showConfirmationDialog(
          yes: 'Continue',
          no: 'Save',
          headerImage: Image.asset(AppAssets.caution, height: 100),
          context,
          title: 'Caution',
          content: contentText(
              "You have unsaved changes. Are you sure you want to exit without saving?"),
        );

        if (result == null || !context.mounted) {
          log('The result was null');
          return;
        }

        if (!result) {
          await onSaveChanges();
        }

        if (context.mounted && result) {
          notifier.resetToStatic();
          Navigator.of(context).pop();
        }
      }
    }

    void onSaveTap() => notifier.saveFilters(showSnackbar: showSnackbar);

    return PopScope(
      canPop: !hasSave.value,
      onPopInvoked: onPopInvoked,
      child: AppScaffold(
        useScrollView: true,
        appBar: CustomAppBar(
          addBarHeight: 4,
          title: 'Preferences',
          onPop: hasSave.value ? () async => await onPopInvoked(false) : null,
          action: Selector<_Notifier, bool>(
            selector: (_, pref) => pref.hasChanges,
            builder: (_, save, __) {
              if (hasSave.value != save) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  hasSave.value = save;
                });
              }
              return save
                  ? Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: TextButton(
                        onPressed: onSaveTap,
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
        ), //
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: const DistanceAgeComponent<_Notifier>(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const MeetComponent<_Notifier>(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const InterestBioComponent<_Notifier>(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const ExtrasComponent<_Notifier>(),
            ),
          ],
        ),
      ),
    );
  }
}

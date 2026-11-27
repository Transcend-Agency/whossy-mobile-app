import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/components.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/provider.dart';
import '../../../preferences/view/widgets/_.dart';

typedef _Notifier = AdvancedSearchNotifier;

@RoutePage()
class AdvancedSearchScreen extends HookWidget {
  const AdvancedSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = useMemoized(() => context.read<_Notifier>());
    // The age section edits the Preferences age filter (one setting in both
    // places), so this screen saves and discards it with its own changes.
    final preferences = useMemoized(() => context.read<PreferencesNotifier>());
    final hasSave = useState<bool>(false);

    Future<void> saveAll() async {
      void onError(String msg) => showSnackbar(msg, context);
      await notifier.saveFilters(showSnackbar: onError);
      await preferences.saveFilters(showSnackbar: onError);
    }

    onSaveChanges() async {
      await saveAll();

      if (!context.mounted) return;

      Navigator.of(context).pop();
    }

    // void onTap() {
    //   showSaveSearchSheet(context: context);
    // }

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
          // Only when there's something to undo: resetToStatic needs the
          // preferences to have loaded.
          if (preferences.hasChanges) preferences.resetToStatic();
          Navigator.of(context).pop();
        }
      }
    }

    void onSaveTap() => saveAll();

    return PopScope(
      canPop: !hasSave.value,
      onPopInvokedWithResult: (didPop, _) => onPopInvoked(didPop),
      child: AppScaffold(
        useScrollView: true,
        appBar: CustomAppBar(
          addBarHeight: 4,
          title: 'Advanced search',
          onPop: hasSave.value ? () async => await onPopInvoked(false) : null,
          action: Selector2<_Notifier, PreferencesNotifier, bool>(
            selector: (_, search, prefs) =>
                search.hasChanges || prefs.hasChanges,
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
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: const AgeFilterComponent(standalone: true),
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

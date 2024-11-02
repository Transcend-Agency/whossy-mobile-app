import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../common/styles/text_style.dart';
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

    void showSnackbar(String message) {
      if (context.mounted) {
        showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
      }
    }

    // Use effect to replace initState
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.getFilters(showSnackbar: showSnackbar);
      });
      return null; // no cleanup needed
    }, []);

    void onSaveTap() => notifier.saveFilters(showSnackbar: showSnackbar);

    return AppScaffold(
      useScrollView: true,
      appBar: CustomAppBar(
        addBarHeight: 4,
        title: 'Preferences',
        action: Selector<_Notifier, bool>(
          selector: (_, pref) => pref.hasChanges,
          builder: (_, save, __) {
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
    );
  }
}

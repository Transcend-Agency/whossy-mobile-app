import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../constants/index.dart';
import 'widgets/_.dart';

@RoutePage()
class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  late PreferencesNotifier _preferencesNotifier;

  @override
  void initState() {
    _preferencesNotifier = context.read<PreferencesNotifier>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preferencesNotifier.getFilters(showSnackbar: showSnackbar);
    });

    super.initState();
  }

  void onSaveTap() {
    _preferencesNotifier.saveFilters(showSnackbar: showSnackbar);
  }

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useScrollView: true,
      appBar: CustomAppBar(
        title: 'Preferences',
        action: Selector<PreferencesNotifier, bool>(
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
            child: const DistanceAgeComponent(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: const MeetComponent(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: const InterestBioComponent(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: const ExtrasComponent(),
          ),
        ],
      ),
    );
  }
}

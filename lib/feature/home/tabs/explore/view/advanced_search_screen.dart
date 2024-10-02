import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/feature/home/tabs/explore/view/widgets/save_search_sheet.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';
import '../../../preferences/view/widgets/_.dart';

typedef _Notifier = AdvancedSearchNotifier;

@RoutePage()
class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  late _Notifier _notifier;

  @override
  void initState() {
    _notifier = context.read<_Notifier>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifier.getFilters(showSnackbar: showSnackbar);
    });

    super.initState();
  }

  void onSaveTap() {
    showSaveSearchSheet(context: context);
    //_notifier.saveFilters(showSnackbar: showSnackbar);
  }

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => _notifier.clear(),
      child: AppScaffold(
        useScrollView: true,
        appBar: CustomAppBar(
          title: 'Advanced search',
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
      ),
    );
  }
}

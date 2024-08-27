import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/provider/providers.dart';

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
    _preferencesNotifier =
        Provider.of<PreferencesNotifier>(context, listen: false);

    _preferencesNotifier.getFilters(showSnackbar: showSnackbar);

    super.initState();
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
      appBar: const CustomAppBar(
        title: 'Preferences',
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../view_model/onboarding_provider.dart';

class EducationScreen extends StatefulWidget {
  final int pageIndex;
  const EducationScreen({super.key, required this.pageIndex});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with AutomaticKeepAliveClientMixin<EducationScreen> {
  late OnboardingProvider onboardingProvider;

  final formKey1 = GlobalKey<FormState>();
  final uniController = TextEditingController();
  final uniFocusNode = FocusNode();

  final _debouncer = Debouncer(milliseconds: 1000);

  void _update() {
    final university = uniController.text;

    if (university.isValidUniversity()) {
      onboardingProvider.select(widget.pageIndex);

      onboardingProvider.updateUserProfile(education: university.trim());
    } else {
      onboardingProvider.select(widget.pageIndex, value: false);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    uniController.addListener(() => _debouncer.run(_update));

    onboardingProvider =
        Provider.of<OnboardingProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Is education your thing?",
          subtitle: 'This will be shown on your profile',
          skip: true,
        ),
        addHeight(24),
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            'School or University',
            style: TextStyles
                .fieldHeader, // Todo: Fix the responsiveness here on smaller devices
          ),
        ),
        Form(
          key: formKey1,
          child: AppTextField(
            focusNode: uniFocusNode,
            textController: uniController,
            hintText: 'Enter school name',
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

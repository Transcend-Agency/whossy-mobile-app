import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';

class EducationScreen extends StatefulWidget {
  final int pageIndex;
  const EducationScreen({super.key, required this.pageIndex});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with AutomaticKeepAliveClientMixin<EducationScreen> {
  final formKey1 = GlobalKey<FormState>();
  final uniController = TextEditingController();
  final uniFocusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

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
            style: TextStyles.fieldHeader,
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

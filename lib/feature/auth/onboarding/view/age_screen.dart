import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/components/TextField/underline_text_field.dart';
import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';

class AgeScreen extends StatefulWidget {
  final int pageIndex;

  const AgeScreen({super.key, required this.pageIndex});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen>
    with AutomaticKeepAliveClientMixin<AgeScreen> {
  final formKey1 = GlobalKey<FormState>();
  final monthController = TextEditingController();
  final dayController = TextEditingController();
  final yearController = TextEditingController();
  final monthFocusNode = FocusNode();
  final dayFocusNode = FocusNode();
  final yearFocusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "How old are you?",
          subtitle:
              'Your age will be displayed alongside your profile excluding your birth date and month.',
        ),
        addHeight(24),
        Form(
          key: formKey1,
          child: Row(
            children: [
              Expanded(
                child: UnderlineTextField(
                  focusNode: monthFocusNode,
                  textController: monthController,
                  hintText: 'MM',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: UnderlineTextField(
                  focusNode: dayFocusNode,
                  textController: dayController,
                  hintText: 'DD',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: UnderlineTextField(
                  focusNode: yearFocusNode,
                  textController: yearController,
                  hintText: 'YYYY',
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

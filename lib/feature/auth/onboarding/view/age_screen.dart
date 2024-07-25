import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/TextField/underline_text_field.dart';
import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';
import '../view_model/onboarding_provider.dart';

class AgeScreen extends StatefulWidget {
  final int pageIndex;

  const AgeScreen({super.key, required this.pageIndex});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen>
    with AutomaticKeepAliveClientMixin<AgeScreen> {
  late OnboardingProvider onboardingProvider;
  final formKey1 = GlobalKey<FormState>();

  final monthController = TextEditingController();
  final dayController = TextEditingController();
  final yearController = TextEditingController();

  final monthFocusNode = FocusNode();
  final dayFocusNode = FocusNode();
  final yearFocusNode = FocusNode();

  void _update() {
    final year = yearController.text;
    final month = monthController.text;
    final day = dayController.text;

    if (year.isValidYear() && month.isValidMonth() && day.isValidDay()) {
      onboardingProvider.select(widget.pageIndex);

      onboardingProvider.updateUserProfile(
        dateOfBirth: getDate(year: year, month: month, day: day),
      );
    } else {
      onboardingProvider.select(widget.pageIndex, value: false);
    }
  }

  @override
  void initState() {
    monthController.addListener(_update);
    dayController.addListener(_update);
    yearController.addListener(_update);

    onboardingProvider =
        Provider.of<OnboardingProvider>(context, listen: false);

    super.initState();
  }

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
                  align: TextAlign.center,
                  action: TextInputAction.next,
                  format: InputFormatter.month(),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: UnderlineTextField(
                  focusNode: dayFocusNode,
                  textController: dayController,
                  hintText: 'DD',
                  align: TextAlign.center,
                  action: TextInputAction.next,
                  format: InputFormatter.day(),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: UnderlineTextField(
                  focusNode: yearFocusNode,
                  textController: yearController,
                  hintText: 'YYYY',
                  align: TextAlign.center,
                  format: InputFormatter.year(),
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

DateTime getDate({
  required String year,
  required String month,
  required String day,
}) {
  return DateTime(
    int.parse(year),
    int.parse(month),
    int.parse(day),
  );
}

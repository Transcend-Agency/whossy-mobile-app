import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/components/TextField/underline_text_field.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';

class BioScreen extends StatefulWidget {
  final int pageIndex;

  const BioScreen({super.key, required this.pageIndex});

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen>
    with AutomaticKeepAliveClientMixin<BioScreen> {
  final formKey1 = GlobalKey<FormState>();
  final textController = TextEditingController();
  final focusNode = FocusNode();

  int _characterCount = 0;
  static const int _maxCharacterCount = 500;

  @override
  void initState() {
    super.initState();
    textController.addListener(updateCounter);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void updateCounter() {
    setState(() {
      _characterCount = textController.text.length;
    });
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
          title: "Your bio: Let others know who you are :)",
          subtitle: 'A short introduction about who you are',
          skip: true,
        ),
        addHeight(24),
        Form(
          key: formKey1,
          child: UnderlineTextField(
            focusNode: focusNode,
            textController: textController,
            maxLength: _maxCharacterCount,
          ),
        ),
        addHeight(2),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '$_characterCount/$_maxCharacterCount characters',
            style: TextStyles.hintText.copyWith(
              fontSize: AppUtils.scale(9.5.sp),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

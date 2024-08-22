import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';

class CitySheet extends StatefulWidget {
  const CitySheet({super.key, required this.city});

  final String? city;

  @override
  State<CitySheet> createState() => _CitySheetState();
}

class _CitySheetState extends State<CitySheet> {
  final cityController = TextEditingController();
  final formKey1 = GlobalKey<FormState>();
  final cityFocusNode = FocusNode();

  late String store;
  bool hasChanged = false;

  void update() {
    setState(() => hasChanged = store != cityController.text);
  }

  @override
  void initState() {
    if (widget.city != null) {
      cityController.text = widget.city!;
    }

    store = cityController.text;

    cityController.addListener(update);

    // Request focus after the widget tree has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(cityFocusNode);
    });

    super.initState();
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: modalPadding.copyWith(
              top: AppUtils.scale(12.h),
              bottom: AppUtils.scale(12.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'City of residence',
                  style: TextStyles.buttonText.copyWith(
                    fontSize: AppUtils.scale(17),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(
                      context, hasChanged ? cityController.text.trim() : null),
                  child: SizedBox.square(
                    dimension: 30.r,
                    child: hasChanged ? checkIcon() : cancelIcon(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.outlinedColor,
            height: 0,
          ),
          addHeight(16),
          Padding(
            padding: pagePadding,
            child: Form(
              key: formKey1,
              child: AppTextField(
                focusNode: cityFocusNode,
                textController: cityController,
                hintText: 'Enter city name',
                prefixIcon: search(),
                lengthLimit: 20,
                padding: 13,
                curvierEdges: true,
              ),
            ),
          ),
          addHeight(16),
        ],
      ),
    );
  }
}

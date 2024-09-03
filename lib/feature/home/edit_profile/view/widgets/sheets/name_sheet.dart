import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class NameSheet extends StatefulWidget {
  final String? name;
  final String title;

  const NameSheet({super.key, this.name, required this.title});

  @override
  State<NameSheet> createState() => _NameSheetState();
}

class _NameSheetState extends State<NameSheet> {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final nameFocusNode = FocusNode();

  late String originalName;
  bool hasChanged = false;

  void update() {
    String currentName = nameController.text;

    bool isNameChanged = originalName != currentName;
    bool isNameValid = currentName.validateName() == null;

    setState(() {
      hasChanged = isNameChanged && isNameValid;
    });
  }

  @override
  void initState() {
    if (widget.name != null) {
      nameController.text = widget.name!;
    }

    originalName = nameController.text;

    nameController.addListener(update);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(nameFocusNode);
    });

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
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
                  widget.title,
                  style: TextStyles.buttonText.copyWith(
                    fontSize: AppUtils.scale(17),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(
                      context, hasChanged ? nameController.text.trim() : null),
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
              key: formKey,
              child: AppTextField(
                focusNode: nameFocusNode,
                textController: nameController,
                hintText: 'Enter your name',
                prefixIcon: search(),
                lengthLimit: 50, // You can adjust this limit
                padding: 13,
                curvierEdges: true,
                validation: (name) => name?.trim().validateName(),
              ),
            ),
          ),
          addHeight(16),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../../../common/components/components.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';

class ReportDialog extends StatefulWidget {
  final Function(String reason, String? customMessage) onSubmit;
  final String name;

  const ReportDialog({required this.onSubmit, super.key, required this.name});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String? _selectedReason;
  final _customMessageController = TextEditingController();

  final customMessageNode = FocusNode();

  final List<String> _reasons = [
    'Harassment or abuse',
    'Spam',
    'Inappropriate content',
    'Impersonation',
    'Other',
  ];

  void _submit() {
    widget.onSubmit(
      _selectedReason!,
      _selectedReason == 'Other' ? _customMessageController.text : null,
    );
  }

  @override
  void dispose() {
    _customMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report ${widget.name}',
              style: TextStyles.boldPrefText.copyWith(
                fontSize: AppUtils.scale(15.sp) ?? 17.sp,
                color: Colors.black87,
              ),
            ),
            // addHeight(8),

            // Temporarily commented this
            // Text(
            //   'Reason for reporting:',
            //   style: TextStyles.boldPrefText.copyWith(
            //     fontSize: AppUtils.scale(12.sp) ?? 13.5.sp,
            //     color: Colors.black87,
            //   ),
            // ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._reasons.map((reason) {
                return RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    reason,
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                      color: Colors.black87,
                    ),
                  ),
                  value: reason,
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                  },
                );
              }),
              if (_selectedReason == 'Other') ...[
                AppTextField(
                  focusNode: customMessageNode,
                  textController: _customMessageController,
                  hintText: 'Your reason in more details',
                  hintStyle: TextStyles.buttonText.copyWith(
                    fontSize: AppUtils.scale(17),
                    color: Colors.black38,
                  ),
                  fillColor: Colors.transparent,
                  customEnabledBorder: inputBorder,
                  customFocusedBorder: focusedBorder,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyles.buttonText.copyWith(
                fontSize: AppUtils.scale(17),
                color: Colors.black87,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _selectedReason == null ? null : _submit,
            style: ElevatedButton.styleFrom(
              shape: circularBorder,
              elevation: 0,
              disabledBackgroundColor: Colors.transparent,
              backgroundColor: AppColors.listTileColor,
            ),
            child: Text(
              'Submit',
              style: TextStyles.buttonText.copyWith(
                fontSize: AppUtils.scale(17),
                color: AppColors.buttonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  final focusedBorder = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.selectedFieldColor,
      width: 2,
    ),
  );

  final inputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  );
}

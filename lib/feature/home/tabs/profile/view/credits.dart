import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import flutter_hooks package
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';
import '../model/credit.dart';

@RoutePage()
class Credits extends HookWidget {
  // Extend HookWidget instead of StatefulWidget
  const Credits({super.key});

  @override
  Widget build(BuildContext context) {
    final creditEnum = useState<Credit?>(null);

    return AppScaffold(
      appBar: const CustomAppBar(
        addBarHeight: 4,
        title: 'Whossy Credits',
        color: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 14.r, right: 14.r, top: 16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.yellowContainer,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(14.r),
              child: Center(
                child: Column(
                  children: [
                    SizedBox.square(
                      dimension: 80.r,
                      child: Image.asset(
                        AppAssets.credit2,
                      ),
                    ),
                    addHeight(6),
                    Text(
                      'Whossy Credits',
                      textAlign: TextAlign.center,
                      style: TextStyles.title.copyWith(
                        fontSize: AppUtils.scale(32) ?? 26,
                      ),
                    ),
                    addHeight(8),
                    Opacity(
                      opacity: 0.9,
                      child: Text(
                        'Buy credits to boost profile and get more visibility on whossy',
                        textAlign: TextAlign.center,
                        style: TextStyles.hintThemeText.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: AppUtils.scale(10.sp) ?? 13.5.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            addHeight(20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: Credit.values.map((data) {
                    return GenericTile(
                      borderColor: AppColors.outlinedColor,
                      tileColor: Colors.white,
                      bottom: 14.r,
                      value: data,
                      groupValue: creditEnum.value,
                      onChanged: (newEnum) => creditEnum.value = newEnum,
                      title: '${data.quantity} Credits',
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addHeight(2),
                          Text(
                            '\$ ${data.price}',
                            style: TextStyles.profileHead.copyWith(
                              fontSize: AppUtils.scale(12.sp) ?? 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.r),
              child: DialogButton(
                text: "Continue",
                color: AppColors.buttonColor,
                textColor: Colors.white,
                onPressed: creditEnum.value == null
                    ? null
                    : () async =>
                        await _addCredits(context, creditEnum.value!.quantity),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCredits(BuildContext context, int credit) async {
    final editNotifier = context.read<EditProfileNotifier>();

    var creditBalance = editNotifier.coreProfile?.creditBalance ?? 0;

    editNotifier.updateProfile(creditBalance: creditBalance + credit);

    bool success = await editNotifier.saveUserProfile(
      showSnackbar: showSnackbar,
      returnResult: true,
    );

    if (!success) {
      editNotifier.updateProfile(creditBalance: creditBalance);
      showSnackbar(AppStrings.addCreditsFailure);

      return;
    }
  }

  showSnackbar(String message) {
    if (useContext().mounted) {
      showTopSnackBar(Overlay.of(useContext()), AppSnackbar(text: message));
    }
  }
}

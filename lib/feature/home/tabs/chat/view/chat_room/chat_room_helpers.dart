part of 'chat_room.dart';

openDialog(BuildContext context) async {
  await showConfirmationDialog(
    yes: 'Continue',
    headerImage: Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Image.asset(
        AppAssets.shield,
        height: 120,
      ),
    ),
    context,
    title: 'Chat safety is a priority',
    content: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
          text: AppStrings.chatSafety,
          style: TextStyles.bioText.copyWith(
            fontSize: AppUtils.scale(11.sp),
          ),
        ),
        TextSpan(
          text: "Safety guide",
          style: TextStyles.bioText.copyWith(
            fontSize: AppUtils.scale(11.sp),
            decoration: TextDecoration.underline,
          ),
        ),
        TextSpan(
          text: " and ",
          style: TextStyles.bioText.copyWith(
            fontSize: AppUtils.scale(11.sp),
          ),
        ),
        TextSpan(
          text: "Privacy policies",
          style: TextStyles.bioText.copyWith(
            fontSize: AppUtils.scale(11.sp),
            decoration: TextDecoration.underline,
          ),
        ),
      ]),
    ),
  );
}

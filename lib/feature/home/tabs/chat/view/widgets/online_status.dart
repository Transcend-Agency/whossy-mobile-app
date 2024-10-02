import 'package:flutter/material.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../constants/index.dart';

class OnlineStatus extends StatelessWidget {
  const OnlineStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Online',
      style: TextStyles.prefText.copyWith(
        color: AppColors.hintTextColor,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

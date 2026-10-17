import 'package:flutter/material.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/utils/discovery_error.dart';
import '../../../../../../constants/index.dart';

Widget buildLoadingIndicator() {
  return const Center(
    key: ValueKey('loading'),
    child: AppLoader(color: AppColors.primaryColor, size: 24),
  );
}

Widget buildErrorWidget(Object? error) {
  final info = discoveryErrorInfo(error);
  return BadNetworkDialog(
    key: const ValueKey('error'),
    title: info.title,
    subtitle: info.subtitle,
  );
}

Widget buildEmptyData() {
  return const EmptyDataBox(
    key: ValueKey('empty'),
    imageSize: 100,
    spacing: 10,
    image: AppAssets.noLikes,
    text: 'All out of profiles! Try again soon',
  );
}

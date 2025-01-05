import 'package:flutter/material.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../constants/index.dart';

Widget buildLoadingIndicator() {
  return const Center(
    key: ValueKey('loading'),
    child: AppLoader(color: AppColors.primaryColor, size: 24),
  );
}

Widget buildErrorWidget(Object? error) {
  return Center(
    key: const ValueKey('error'),
    child: Text('Error: $error'),
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

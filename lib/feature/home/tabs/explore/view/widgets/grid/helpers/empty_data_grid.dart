import 'package:flutter/material.dart';

import '../../../../../../../../common/components/components.dart';
import '../../../../../../../../constants/index.dart';

class EmptyDataGrid extends StatelessWidget {
  const EmptyDataGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyDataBox(
      key: ValueKey('empty'),
      imageSize: 100,
      image: AppAssets.noLikes,
      text: 'No search results',
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../../../common/components/index.dart';

class ErrorGrid extends StatelessWidget {
  final Object? error;
  const ErrorGrid({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return const BadNetworkDialog(
      key: ValueKey('error'),
    );
  }
}

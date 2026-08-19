import 'package:flutter/material.dart';

import '../../../../../../../../common/components/components.dart';
import '../../../../../../../../common/utils/discovery_error.dart';

class ErrorGrid extends StatelessWidget {
  final Object? error;
  const ErrorGrid({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final info = discoveryErrorInfo(error);
    return BadNetworkDialog(
      key: const ValueKey('error'),
      title: info.title,
      subtitle: info.subtitle,
    );
  }
}

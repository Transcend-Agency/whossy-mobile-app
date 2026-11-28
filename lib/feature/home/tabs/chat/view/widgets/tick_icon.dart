import 'package:flutter/material.dart';

import '../../../../../../constants/colors.dart';
import '../../model/delivery.dart';

/// The ticks under one of your own messages:
/// a clock while it waits to send, one grey tick once sent, two grey ticks
/// once their phone has it, and two blue ticks once they have read it.
class TickIcon extends StatelessWidget {
  const TickIcon(this.state, {super.key, this.size = 16});

  final TickState state;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (state) {
      TickState.pending => (
          Icons.schedule_rounded,
          AppColors.messageMetaColor,
          'Sending',
        ),
      TickState.sent => (Icons.check, AppColors.messageMetaColor, 'Sent'),
      TickState.delivered => (
          Icons.done_all,
          AppColors.messageMetaColor,
          'Delivered',
        ),
      TickState.read => (Icons.done_all, AppColors.readTickColor, 'Read'),
    };

    return Icon(
      icon,
      key: ValueKey('tick_${state.name}'),
      size: state == TickState.pending ? size - 2 : size + 2,
      color: color,
      semanticLabel: label,
    );
  }
}

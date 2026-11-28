import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../../constants/colors.dart';

/// Swipe a message to the right to reply to it. The message follows the
/// finger, a reply arrow fades in behind it, and the phone gives a light tap
/// once the swipe is far enough to count.
class SwipeToReply extends StatefulWidget {
  const SwipeToReply({
    super.key,
    required this.child,
    required this.onReply,
  });

  final Widget child;
  final VoidCallback onReply;

  /// How far the swipe has to go to reply.
  static const threshold = 56.0;

  /// The furthest the message moves.
  static const maxDrag = 80.0;

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  double _dx = 0;
  double _releasedAt = 0;
  bool _armed = false;

  late final AnimationController _snapBack = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  )..addListener(() {
      setState(() {
        _dx = _releasedAt * (1 - Curves.easeOut.transform(_snapBack.value));
      });
    });

  @override
  void dispose() {
    _snapBack.dispose();
    super.dispose();
  }

  void _onUpdate(DragUpdateDetails details) {
    _snapBack.stop();
    setState(() {
      _dx = (_dx + details.delta.dx).clamp(0.0, SwipeToReply.maxDrag);
    });

    final past = _dx >= SwipeToReply.threshold;
    if (past && !_armed) HapticFeedback.lightImpact();
    _armed = past;
  }

  void _onEnd([DragEndDetails? _]) {
    if (_armed) widget.onReply();
    _armed = false;
    _releasedAt = _dx;
    _snapBack.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_dx / SwipeToReply.threshold).clamp(0.0, 1.0);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      onHorizontalDragCancel: _onEnd,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (_dx > 0)
            Positioned(
              left: 12,
              child: Opacity(
                opacity: progress,
                child: Transform.scale(
                  scale: 0.6 + 0.4 * progress,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.listTileColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.reply_rounded,
                      size: 18,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
          Transform.translate(
            offset: Offset(_dx, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

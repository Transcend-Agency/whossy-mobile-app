import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';

class MatchIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final String assetPath;
  final double? size;
  final double? padding;
  final Color backgroundColor;
  final List<BoxShadow>? shadow;
  final VoidCallback? onAnimationComplete;
  final bool animateOnTap; // Flag to enable or disable animation

  const MatchIconButton({
    super.key,
    required this.onTap,
    required this.assetPath,
    this.size,
    this.padding,
    this.backgroundColor = Colors.white,
    this.shadow,
    this.onAnimationComplete,
    this.animateOnTap = false, // Default value is false
  });

  @override
  State<MatchIconButton> createState() => _MatchIconButtonState();
}

class _MatchIconButtonState extends State<MatchIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.animateOnTap) {
      _controller.forward().then((_) {
        widget.onTap();
      });
    } else {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.animateOnTap ? _sizeAnimation.value : 1.0,
            child: Opacity(
              opacity: widget.animateOnTap ? _opacityAnimation.value : 1.0,
              child: Container(
                padding: EdgeInsets.all(widget.padding ?? 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.backgroundColor,
                  boxShadow: widget.shadow ?? [matchButtonShadow],
                ),
                child: Image.asset(
                  widget.assetPath,
                  width: (widget.size ?? 36).r,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

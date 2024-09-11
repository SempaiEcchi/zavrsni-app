import 'package:flutter/material.dart';

class AnimatedTapButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final HitTestBehavior behavior;
  const AnimatedTapButton({
    super.key,
    required this.child,
    this.behavior = HitTestBehavior.opaque,
    this.onTap,
  });

  @override
  State<AnimatedTapButton> createState() => _AnimatedTapButtonState();
}

class _AnimatedTapButtonState extends State<AnimatedTapButton>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  late final Animation<double> scale =
      Tween<double>(begin: 1, end: 0.98).animate(controller);

  Offset? tdPos;

  @override
  Widget build(BuildContext context) {
    var child = AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Transform.scale(
              scale: scale.value,
              child: child,
            ),
        child: widget.child);

    if (widget.onTap == null) return child;
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: (_) async {
        tdPos = _.globalPosition;
        await controller.forward();
        await controller.reverse();
      },
      onTapCancel: () async {
        widget.onTap?.call();
      },
      onTapUp: (_) async {
        if (tdPos != null && (tdPos! - _.globalPosition).distance > 60) {
          tdPos = null;
          return;
        }

        widget.onTap?.call();
      },
      child: child,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackGesture extends StatelessWidget {
  final Widget child;

  CustomBackGesture({
    super.key,
    required this.child,
  });
  DragStartDetails? tdd;
  @override
  Widget build(BuildContext context) {
    if (kIsWeb && MediaQuery.of(context).size.width > 700) return child;
    return GestureDetector(
      onHorizontalDragStart: (d) {
        tdd = d;
      },
      onHorizontalDragUpdate: (d) {
        if (tdd!.globalPosition.dx < MediaQuery.of(context).size.width / 2) {
          if (d.globalPosition.dx - tdd!.globalPosition.dx > 130) {
            GoRouter.of(context).pop();
          }
        }
      },
      child: WillPopScope(
        child: child,
        onWillPop: () async {
          if (kIsWeb) return true;
          return false;
        },
      ),
    );
  }
}

import 'package:firmus/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';
import 'package:go_router/go_router.dart';

class FirmusBackButton extends StatelessWidget {
  final Color? color;
  const FirmusBackButton({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          GoRouter.of(context).pop();
        },
        icon: Assets.images.arrowBack
            .image(width: 30, color: color ?? Theme.of(context).primaryColor));
  }
}

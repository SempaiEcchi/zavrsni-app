import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConstrainedBody extends StatelessWidget {
  final Widget child;
  final bool center;

  final bool onlyWeb;

  @override
  Widget build(BuildContext context) {
    if (onlyWeb && !kIsWeb) return this.child;

    bool isTablet = MediaQuery.of(context).size.width > 600;

    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isTablet ? 650 : 400),
        child: this.child,
      ),
    );

    if (!center) return child;

    return Center(
      child: child,
    );
  }

  const ConstrainedBody({
    super.key,
    required this.child,
    this.onlyWeb = false,
    this.center = true,
  });

  const ConstrainedBody.onlyWeb({
    super.key,
    required this.child,
    this.onlyWeb = true,
    this.center = true,
  });
}

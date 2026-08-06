import 'package:flutter/material.dart';

class ResponsiveScreen extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool safeArea;

  const ResponsiveScreen({
    super.key,
    required this.child,
    this.backgroundColor,
    this.safeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              maxWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(child: child),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      body: safeArea ? SafeArea(child: content) : content,
    );
  }
}

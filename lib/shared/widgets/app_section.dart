import 'package:flutter/material.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

class AppSection extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const AppSection({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor ?? Theme.of(context).cardTheme.color,
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.md,
          ),
      child: child,
    );
  }
}

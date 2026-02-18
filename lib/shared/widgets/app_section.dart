import 'package:flutter/material.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

class AppSection extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Color? backgroundColor;

  const AppSection({
    super.key,
    required this.child,
    this.padding,
    this.horizontalPadding,
    this.verticalPadding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor ?? Theme.of(context).cardTheme.color,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? AppSizes.lg,
            vertical: verticalPadding ?? AppSizes.md,
          ),
      child: child,
    );
  }
}

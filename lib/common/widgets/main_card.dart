import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class MainCardWidget extends StatelessWidget {
  const MainCardWidget({
    super.key,
    required this.child,
    this.padding,
    this.color,
  });

  final Widget child;
  final Color? color;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color ?? AppColors.white,
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 40),
        ],
      ),
      child: child,
    );
  }
}

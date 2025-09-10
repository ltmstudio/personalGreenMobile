import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class SelectBtn extends StatelessWidget {
  const SelectBtn({
    super.key,
    required this.title,
    this.value,
    required this.icon,
    this.color,
    required this.onTap,
    required this.showBorder,
  });

  final String title;
  final String? value;
  final Widget icon;
  final Color? color;
  final VoidCallback onTap;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(4, 0, 4, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color ?? AppColors.white,
          border: showBorder
              ? Border.all(color: AppColors.lightGrayBorder)
              : null,
          boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 40)],
        ),
        padding: EdgeInsets.zero,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          title: Text(
            value ?? title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: value != null ? AppColors.primary : AppColors.gray,
            ),
          ),
          trailing: icon,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class SelectBtn extends StatelessWidget {
  const SelectBtn({super.key, required this.title, required this.icon, this.color, required this.onTap});
  final String title;
  final Widget icon;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(4, 0, 4, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color ?? AppColors.white,
          boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 40)],
        ),
        padding: EdgeInsets.zero,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          title: Text(
           title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.gray),
          ),
          trailing: icon,
        ),
      ),
    );
  }
}

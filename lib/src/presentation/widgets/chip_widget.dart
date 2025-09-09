import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class ChipWidget extends StatelessWidget {
  const ChipWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      backgroundColor: AppColors.whiteG,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
    );
  }
}

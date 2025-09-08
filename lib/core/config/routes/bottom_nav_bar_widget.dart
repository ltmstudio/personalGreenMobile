import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final ValueChanged<int> onTap;
  final int currentIndex;
  final List<BottomNavigationBarItem> items;

  const BottomNavBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      selectedItemColor:  Theme.of(context).iconTheme.color,
      unselectedItemColor: AppColors.gray,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 10,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/widget_keys_str.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'bottom_nav_bar_widget.dart';

class ScaffoldWithNestedNavigation extends StatefulWidget {
  const ScaffoldWithNestedNavigation({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNestedNavigation> createState() =>
      _ScaffoldWithNestedNavigationState();
}

class _ScaffoldWithNestedNavigationState
    extends State<ScaffoldWithNestedNavigation> {
  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  List<BottomNavigationBarItem> items = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    items = [
      BottomNavigationBarItem(
        label: '',

        icon: buildIcon(IconAssets.person, color: AppColors.gray),
        activeIcon: buildIcon(IconAssets.person, color: AppColors.darkBlue),
      ),
      BottomNavigationBarItem(
        label: '',

        icon: buildIcon(IconAssets.options, color: AppColors.gray),
        activeIcon: buildIcon(IconAssets.options, color: AppColors.darkBlue),
      ),
      BottomNavigationBarItem(
        label: '',
        icon: buildIcon(IconAssets.support, color: AppColors.gray),
        activeIcon: buildIcon(IconAssets.support, color: AppColors.darkBlue),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 44,
        ),
        child: widget.navigationShell,
      ),
      bottomNavigationBar: buildBottomWidget(),
    );
  }

  Widget buildBottomWidget() {
    return BottomNavBar(
      key: bottomNavBarKey,
      onTap: _goBranch,
      currentIndex: widget.navigationShell.currentIndex,
      items: items,
    );
  }

  Widget buildIcon(String iconPath, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: SvgPicture.asset(iconPath, color: color),
    );
  }
}

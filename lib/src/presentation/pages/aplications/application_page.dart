import 'package:flutter/material.dart';
import 'package:hub_dom/common/widgets/appbar_icon.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';

class ApplicationPage extends StatelessWidget {
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.applications),
        actions: [
          AppBarIcon(icon: IconAssets.scanner, onTap: (){}),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: AppBarIcon(icon: IconAssets.filter, onTap: (){}),
          ),
        ],
      ),
    );
  }
}

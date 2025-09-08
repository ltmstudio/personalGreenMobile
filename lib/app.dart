import 'package:flutter/material.dart';

import 'common/widgets/scroll_behavior.dart';
import 'core/config/routes/app_router.dart';
import 'core/config/theme/app_theme.dart';
import 'core/constants/strings/app_strings.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const NoGlowScrollBehavior(),
      routerConfig: goRouter,
    );
  }
}

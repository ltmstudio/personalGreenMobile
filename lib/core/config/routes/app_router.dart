
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/config/routes/scaffold_with_nested_nav.dart';
import 'package:hub_dom/core/config/routes/widget_keys_str.dart';
import 'package:hub_dom/src/presentation/pages/aplications/application_page.dart';
import 'package:hub_dom/src/presentation/pages/auth/sign_in_page.dart';
import 'package:hub_dom/src/presentation/pages/auth/verification_page.dart';
import 'package:hub_dom/src/presentation/pages/splash/splash_screen.dart';

final goRouter = GoRouter(
  initialLocation: AppRoutes.applications,
  navigatorKey: rootNavKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: shellNavKey1,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: Scaffold());
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: shellNavKey2,
          routes: [
            GoRoute(
              path: AppRoutes.applications,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  // child: UserOrderPage(),
                  child: ApplicationPage(),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: shellNavKey3,
          routes: [
            GoRoute(
              path: AppRoutes.chat,
              pageBuilder: (context, state) {
                return NoTransitionPage(child: Scaffold());
              },
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) {
        return SplashScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.signIn,
      builder: (context, state) {
        return SignInPage();
      },
    ),
    GoRoute(
      path: AppRoutes.verification,
      builder: (context, state) {
        return VerificationPage(phoneNumber: '7(473)3004001',);
      },
    ),
    // GoRoute(
    //   path: AppRoutes.changePassword,
    //   builder: (context, state) {
    //     return ChangePasswordPage();
    //   },
    // ),
    // GoRoute(
    //   path: AppRoutes.newPassword,
    //   builder: (context, state) {
    //     return NewPasswordPage();
    //   },
    // ),
    // GoRoute(
    //   path: AppRoutes.confirmPassword,
    //   builder: (context, state) {
    //     return ConfirmPasswordPage();
    //   },
    // ),

  ],
);

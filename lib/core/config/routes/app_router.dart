import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/config/routes/scaffold_with_nested_nav.dart';
import 'package:hub_dom/core/config/routes/widget_keys_str.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/data/models/auth/auth_params.dart';
import 'package:hub_dom/data/models/auth/crm_system_model.dart';
import 'package:hub_dom/presentation/pages/address_details/address_details_page.dart';
import 'package:hub_dom/presentation/pages/applications/app_category/app_category_page.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/application_details_page.dart';
import 'package:hub_dom/presentation/pages/applications/create_application/create_aplication_page.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/application_page.dart';
import 'package:hub_dom/presentation/pages/applications/manager_tickets/manager_tickets_page.dart';
import 'package:hub_dom/presentation/pages/auth/profile_page.dart';
import 'package:hub_dom/presentation/pages/auth/security_code_page.dart';
import 'package:hub_dom/presentation/pages/auth/sign_in_page.dart';
import 'package:hub_dom/presentation/pages/auth/verification_page.dart';
import 'package:hub_dom/presentation/pages/emloyee/create_employee_app/create_employee_app_page.dart';
import 'package:hub_dom/presentation/pages/emloyee/employee_app_details/employee_app_details_page.dart';
import 'package:hub_dom/presentation/pages/emloyee/new_employee_app/new_employee_app_page.dart';
import 'package:hub_dom/presentation/pages/emloyee/organization_details/organization_details.dart';
import 'package:hub_dom/presentation/pages/emloyee/organizations/organizations_page.dart';
import 'package:hub_dom/presentation/pages/performer_details/performer_details_page.dart';
import 'package:hub_dom/presentation/pages/scanner/scanner_page.dart';
import 'package:hub_dom/presentation/pages/splash/splash_screen.dart';
import 'package:hub_dom/presentation/pages/support/contacts_page.dart';
import 'package:hub_dom/presentation/pages/support/object_details_page.dart';
import 'package:hub_dom/presentation/pages/support/objects_page.dart';
import 'package:hub_dom/presentation/pages/support/support_page.dart';

// Константа оставлена для обратной совместимости, но теперь навигация происходит динамически через splash screen
bool isMain = false;

final List<StatefulShellBranch> mainBranches = [
  StatefulShellBranch(
    navigatorKey: shellNavKey1,
    routes: [
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: ProfilePage());
        },
      ),
    ],
  ),

  StatefulShellBranch(
    navigatorKey: shellNavKey2,
    initialLocation: AppRoutes.applications,
    routes: [
      // Добавляем оба роута в один branch - GoRouter должен правильно обрабатывать это
      GoRoute(
        path: AppRoutes.applications,
        pageBuilder: (context, state) {
          return NoTransitionPage(child: ApplicationPage());
        },
      ),
      GoRoute(
        path: AppRoutes.organizations,
        pageBuilder: (context, state) {
          return NoTransitionPage(child: OrganizationPage());
        },
        routes: [
          // Добавляем organizationDetails как дочерний роут, чтобы bottom navigation оставался видимым
          GoRoute(
            path: 'organizationDetails',
            builder: (context, state) {
              if (state.extra != null && state.extra is Map<String, dynamic>) {
                final extra = state.extra as Map<String, dynamic>;
                final CrmSystemModel model = extra['model'];
                return OrganizationDetailsPage(model: model);
              }
              return Scaffold(
                appBar: AppBar(),
                body: Center(child: Text(AppStrings.error)),
              );
            },
          ),
        ],
      ),
    ],
  ),

  StatefulShellBranch(
    navigatorKey: shellNavKey3,
    routes: [
      GoRoute(
        path: AppRoutes.support,
        pageBuilder: (context, state) {
          return NoTransitionPage(child: SupportPage());
        },
      ),
    ],
  ),
];

final goRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  navigatorKey: rootNavKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: mainBranches,
    ),

    // organizationDetails теперь находится внутри StatefulShellRoute для сохранения bottom navigation
    // Удаляем старый роут, так как он теперь внутри branch
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
    // GoRoute(
    //   path: '${AppRoutes.verification}/:phone',
    //
    //   builder: (context, state) {
    //     final phone = state.pathParameters['phone'] ?? '';
    //
    //     return VerificationPage(phoneNumber: phone);
    //   },
    // ),
    GoRoute(
      path: AppRoutes.verification,
      builder: (context, state) {
        if (state.extra != null && state.extra is Map<String, dynamic>) {
          final extra = state.extra as Map<String, dynamic>;

          final LoginParams loginParams = extra['params'];

          return VerificationPage(params: loginParams);
        }

        return Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(AppStrings.error)),
        );
      },
    ),
    // GoRoute(
    //   path: AppRoutes.securityCodePage,
    //   builder: (context, state) {
    //     if (state.extra != null && state.extra is Map<String, dynamic>) {
    //      // final extra = state.extra as Map<String, dynamic>;
    //
    //      // final LoginParams loginParams = extra['params'];
    //
    //       return SecurityCodePage();
    //     }
    //
    //     return Scaffold(
    //       appBar: AppBar(),
    //       body: Center(child: Text(AppStrings.error)),
    //     );
    //   },
    // ),
    GoRoute(
      path: AppRoutes.securityCodePage,
      builder: (context, state) {
        return SecurityCodePage();
      },
    ),
    GoRoute(
      path: AppRoutes.createApplication,
      builder: (context, state) {
        return CreateApplicationPage();
      },
    ),
    GoRoute(
      path: '${AppRoutes.appCategory}/:title',

      builder: (context, state) {
        final title = state.pathParameters['title'] ?? '';

        return AppCategoryPage(title: title);
      },
    ),
    GoRoute(
      path: AppRoutes.managerTickets,
      builder: (context, state) {
        // Получаем initialTab и selectedDate из extra
        int initialTab = 0;
        DateTimeRange<DateTime>? selectedDate;
        if (state.extra != null && state.extra is Map<String, dynamic>) {
          final extra = state.extra as Map<String, dynamic>;
          initialTab = extra['initialTab'] ?? 0;
          selectedDate = extra['selectedDate'] as DateTimeRange<DateTime>?;
          debugPrint(
            '[AppRouter] ManagerTicketsPage: initialTab=$initialTab, selectedDate=$selectedDate',
          );
        }

        return ManagerTicketsPage(
          initialTab: initialTab,
          initialSelectedDate: selectedDate,
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.performerDetails}/:title',

      builder: (context, state) {
        final title = state.pathParameters['title'] ?? '';

        return PerformerDetailsPage(title: title);
      },
    ),
    GoRoute(
      path: '${AppRoutes.addressDetails}/:title',

      builder: (context, state) {
        final title = state.pathParameters['title'] ?? '';

        return AddressDetailsPage(title: title);
      },
    ),
    GoRoute(
      path: AppRoutes.applicationDetails,
      builder: (context, state) {
        return ApplicationDetailsPage();
      },
    ),
    GoRoute(
      path: '${AppRoutes.applicationDetails}/:ticketId',
      builder: (context, state) {
        final ticketIdStr = state.pathParameters['ticketId'] ?? '';
        final ticketId = int.tryParse(ticketIdStr);
        if (ticketId == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Неверный ID заявки')),
          );
        }
        return ApplicationDetailsPage(ticketId: ticketId);
      },
    ),

    GoRoute(
      path: AppRoutes.scanner,
      builder: (context, state) {
        return MobileScannerCustom();
      },
    ),

    GoRoute(
      path: '${AppRoutes.employeeAppDetails}/:title',

      builder: (context, state) {
        final title = state.pathParameters['title'] ?? '';

        // Получаем ticketId из extra или извлекаем из title
        int? ticketId;
        if (state.extra != null && state.extra is Map<String, dynamic>) {
          final extra = state.extra as Map<String, dynamic>;
          ticketId = extra['ticketId'] as int?;
        }

        // Если ticketId не передан через extra, пытаемся извлечь из title
        if (ticketId == null && title.contains('№')) {
          final match = RegExp(r'№(\d+)').firstMatch(title);
          if (match != null) {
            ticketId = int.tryParse(match.group(1)!);
          }
        }

        return EmployeeAppDetailsPage(title: title, ticketId: ticketId);
      },
    ),

    GoRoute(
      path: AppRoutes.createEmployeeApp,
      builder: (context, state) {
        return CreateEmployeeAppPage();
      },
    ),

    GoRoute(
      path: AppRoutes.newEmployeeApp,
      builder: (context, state) {
        return NewEmployeeAppsPage();
      },
    ),
    GoRoute(
      path: AppRoutes.contacts,
      builder: (context, state) {
        return ContactsPage();
      },
    ),
    GoRoute(
      path: AppRoutes.objects,
      builder: (context, state) {
        return ObjectsPage();
      },
    ),
    GoRoute(
      path: AppRoutes.objectDetails,
      builder: (context, state) {
        return ObjectDetailsPage();
      },
    ),
  ],
);

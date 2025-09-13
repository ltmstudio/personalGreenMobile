import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/presentation/bloc/auth_bloc/user_auth_bloc.dart';
import 'package:hub_dom/presentation/bloc/otp_cubit/otp_cubit.dart';

import 'locator.dart';
import 'presentation/widgets/scroll_behavior.dart';
import 'core/config/routes/app_router.dart';
import 'core/config/theme/app_theme.dart';
import 'core/constants/strings/app_strings.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserAuthBloc>(
          create: (context) => locator<UserAuthBloc>(),
        ),
        BlocProvider<OtpCubit>(create: (context) => locator<OtpCubit>()),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme(),
        debugShowCheckedModeBanner: false,
        scrollBehavior: const NoGlowScrollBehavior(),
        routerConfig: goRouter,
      ),
    );
  }
}

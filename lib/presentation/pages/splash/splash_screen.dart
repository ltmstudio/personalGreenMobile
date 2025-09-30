import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/auth_bloc/user_auth_bloc.dart';
import 'package:hub_dom/presentation/bloc/selected_crm/selected_crm_cubit.dart';
import 'package:hub_dom/presentation/widgets/main_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  _startDelay() async {
    _timer = Timer(const Duration(milliseconds: 3000), _goNext);
  }

  void _goNext() async {
    final isRegistered = locator<UserAuthBloc>().state;
    final isCrmRegistered = locator<SelectedCrmCubit>().state;

    if (!mounted) return;

    if (isRegistered is UserAuthenticated) {

      if(isCrmRegistered is SelectedCrmRegistered){
          context.go(AppRoutes.organizations);
      }

   //   context.go(AppRoutes.applications);
    } else {
     context.go(AppRoutes.signIn);
    }
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MainLogoWidget(),
      ),
    );
  }
}


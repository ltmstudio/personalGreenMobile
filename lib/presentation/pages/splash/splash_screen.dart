import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/local/token_store.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/auth_bloc/user_auth_bloc.dart';
import 'package:hub_dom/presentation/widgets/main_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _hasNavigated = false;

  _startDelay() async {
    _timer = Timer(const Duration(milliseconds: 3000), _goNext);
  }

  void _goNext() async {
    if (_hasNavigated) return;
    
    final isRegistered = locator<UserAuthBloc>().state;

    if (!mounted) return;

    if (isRegistered is UserAuthenticated) {
      _hasNavigated = true;

      final isResponsible = await  locator<Store>().getIsResponsible() ?? false;

      if(isResponsible){
        context.go(AppRoutes.applications);

      }else{
        context.go(AppRoutes.organizations);
      }

      // Если пользователь уже залогинен, переходим на дефолтную страницу
      // Проверка isResponsible происходит в SecurityCodePage после логина
    } else {
      _hasNavigated = true;
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

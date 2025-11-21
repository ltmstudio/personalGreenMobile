import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/auth_bloc/user_auth_bloc.dart';
import 'package:hub_dom/presentation/bloc/is_responsible/is_responsible_cubit.dart';
import 'package:hub_dom/presentation/widgets/main_logo_widget.dart';

import '../../../core/config/routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  StreamSubscription? _subscription;
  Timer? _timeoutTimer;
  bool _hasNavigated = false;

  _startDelay() async {
    _timer = Timer(const Duration(milliseconds: 3000), _goNext);
  }

  void _goNext() async {
    if (_hasNavigated) return;
    
    final isRegistered = locator<UserAuthBloc>().state;
    final isResponsibleCubit = locator<IsResponsibleCubit>();

    if (!mounted) return;

    if (isRegistered is UserAuthenticated) {
      // Проверяем isResponsible через API
      isResponsibleCubit.checkIsResponsible();
      
      // Слушаем изменения состояния
      _subscription = isResponsibleCubit.stream.listen((state) {
        if (_hasNavigated || !mounted) return;
        
        if (state is IsResponsibleLoaded) {
          _hasNavigated = true;
          _subscription?.cancel();
          _timeoutTimer?.cancel();
          isMain = state.isResponsible;

          // Для руководителя и сотрудника открываем средний таб (branch 1) с дашбордом ApplicationPage
          debugPrint('[SplashScreen] Navigating to applications, isMain: $isMain');
          context.go(AppRoutes.applications);
        } else if (state is IsResponsibleError) {
          // При ошибке используем значение по умолчанию (false - для сотрудника)
          _hasNavigated = true;
          _subscription?.cancel();
          _timeoutTimer?.cancel();
          context.go(AppRoutes.applications);
        }
      });
      
      // Таймаут на случай, если ответ не придет
      _timeoutTimer = Timer(const Duration(seconds: 5), () {
        if (!_hasNavigated && mounted) {
          _hasNavigated = true;
          _subscription?.cancel();
          context.go(AppRoutes.applications);
        }
      });
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
    _subscription?.cancel();
    _timeoutTimer?.cancel();
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


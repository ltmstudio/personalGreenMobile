import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/src/presentation/widgets/main_logo_widget.dart';

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
    // final isRegistered = locator<AuthBloc>().state;
    //
    // if (!mounted) return;
    //
    // if (isRegistered is Authenticated) {
    //   context.go(AppRoutes.orderPage);
    // } else {
    //  context.go(AppRoutes.signIn);
    //}
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


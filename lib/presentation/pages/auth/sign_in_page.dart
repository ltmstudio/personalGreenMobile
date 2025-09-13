import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/data/models/auth/auth_params.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/otp_cubit/otp_cubit.dart';
import 'package:hub_dom/presentation/widgets/k_textfield.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/main_logo_widget.dart';
import 'package:hub_dom/presentation/widgets/toast_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _phoneCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final otpCubit = locator<OtpCubit>();

  @override
  void initState() {
    super.initState();
    _phoneCtrl.addListener(() {
      setState(() {}); // rebuilds the widget whenever text changes
    });
    otpCubit.initializeState();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  bool validate() {
    bool isValid = formKey.currentState?.validate() ?? false;

    return isValid;
  }

  bool isDisableBtn() {
    if (_phoneCtrl.text.length == 10) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.center, child: MainLogoWidget()),
                SizedBox(height: 40),

                Text(
                  AppStrings.signIn,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 40),
                Form(
                  key: formKey,
                  child: TextFieldTitle(
                    title: AppStrings.phoneNumber,
                    child: PhoneNumField(
                      phoneCtrl: _phoneCtrl,
                      isSubmitted: false,
                      hint: AppStrings.phoneHintText,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                    children: [
                      const TextSpan(text: "Продолжая, Вы соглашаетесь на "),
                      TextSpan(
                        text: "обработку персональных данных",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.5,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                        // Add tap gesture if needed
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Персональные данные tapped");
                          },
                      ),
                      const TextSpan(text: " и с "),
                      TextSpan(
                        text: "политикой конфиденциальности",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.5,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Политика конфиденциальности tapped");
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                BlocConsumer<OtpCubit, OtpState>(
                  listener: (context, state) {
                    if (state is OtpLoaded) {
                      final data = state.data;
                      final params = LoginParams(
                        phoneNumber: _phoneCtrl.text.trim(),
                        code: data.code,
                        session: data.session,
                      );
                      // context.push('${AppRoutes.verification}/${_phoneCtrl.text.trim()}');

                      log(params.toString(), name: 'params');

                      context.go(
                        AppRoutes.verification,
                        extra: {"params": params},
                      );
                    } else if (state is OtpError) {
                      showNumberNotRegisteredDialog(context);
                    } else if (state is OtpConnectionError) {
                      Toast.show(context, AppStrings.noInternet);
                    }
                  },
                  builder: (context, state) {
                    return MainButton(
                      buttonTile: AppStrings.login,
                      onPressed: () {
                        if (validate()) {
                          final int? phoneNumber = int.tryParse(
                            _phoneCtrl.text.trim(),
                          );

                          if (phoneNumber != null) {
                            otpCubit.sendOtp(phoneNumber);
                          }
                        }
                      },
                      isDisable: isDisableBtn(),
                      isLoading: state is OtpLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showNumberNotRegisteredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap OK
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.all(15),
          title: Text(
            "Номер не зарегистрирован",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Ваш номер телефона не зарегистрирован в системе «Дом коннект». "
            "Обратитесь в вашу организацию для добавления сотрудника.",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
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
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset(
                          ImageAssets.splashLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppStrings.appName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Персонал',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
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

                      context.go(
                        AppRoutes.verification,
                        extra: {"params": params},
                      );
                    } else if (state is OtpError) {
                      showNumberNotRegisteredDialog(context, state.code);
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

  void showNumberNotRegisteredDialog(BuildContext context, int statusCode) {
    String title;
    String body;

    switch (statusCode) {
      case 429:
        title = AppStrings.tryLater;
        body = AppStrings.tryLaterBody;
        break;
      case 409:
        title = AppStrings.loggedInNumber;
        body = AppStrings.loggedInNumberBody;
        break;
      case 423:
        title = AppStrings.lockedNumber;
        body = AppStrings.lockedNumberBody;
        break;
      default:
        title = AppStrings.phoneNotRegistered;
        body = AppStrings.phoneNotRegisteredBody;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.all(15),
          title: Text(
            AppStrings.phoneNotRegistered,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          content: Text(
            AppStrings.phoneNotRegisteredBody,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppStrings.ok),
            ),
          ],
        );
      },
    );
  }
}

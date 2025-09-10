import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/otp_timer/otp_timer_bloc.dart';
import 'package:pinput/pinput.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final timerBloc = locator<OtpTimerBloc>();

  @override
  void initState() {
    super.initState();

    timerBloc.add(OtpTimerStartedEvent(minutes: 1, seconds: 00));
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool disableButton() {
    if (pinController.text.length == 4) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 55,
      height: 55,
      textStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGrayBorder, width: 1.2),
      ),
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 90),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.verification,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  '${AppStrings.verificationSend} +${widget.phoneNumber}',

                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 40),

              //  VerificationErrorWidget()
              Column(
                children: [
                  Form(
                    key: formKey,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        length: 4,
                        controller: pinController,
                        focusNode: focusNode,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        defaultPinTheme: defaultPinTheme,
                        separatorBuilder: (index) => const SizedBox(width: 12),
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onCompleted: (pin) {
                          debugPrint('onCompleted: $pin');
                        },
                        validator: (s) {
                          return s == '2222'
                              ? null
                              : AppStrings.wrongVerification;
                        },
                        onChanged: (value) {
                          debugPrint('onChanged: $value');
                          setState(() {});
                          disableButton();
                        },
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              width: 1.5,
                              height: 33,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.lightGrayBorder,
                              width: 1.2,
                            ),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.lightGrayBorder,
                              width: 1.2,
                            ),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyBorderWith(
                          border: Border.all(color: Colors.redAccent),
                        ),
                        errorTextStyle: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: AppColors.red),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  BlocProvider.value(
                    value: timerBloc,
                    child: BlocConsumer<OtpTimerBloc, OtpTimerState>(
                      listener: (context, state) {
                        if (state is OtpTimeOver) {
                          //   context.go(AppRoutes.profile);
                        }
                      },
                      builder: (context, state) {
                        if (state is OtpTimeOver) {
                          return TextButton(
                            onPressed: () {
                              timerBloc.add(
                                OtpTimerStartedEvent(minutes: 1, seconds: 00),
                              );
                            },
                            child: Text(
                              AppStrings.verificationSendMore,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }

                        return Text(
                          '${AppStrings.verificationSendAgain}  ${state.minutes}:${state.seconds.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.gray),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        const TextSpan(text: "Продолжая, Вы соглашаетесь на "),
                        TextSpan(
                          text: "обработку персональных данных",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
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
                  MainButton(
                    buttonTile: AppStrings.confirm,
                    onPressed: () {
                      showNumberNotRegisteredDialog(context);
                    },
                    isLoading: false,
                    isDisable: disableButton(),
                  ),
                ],
              ),
            ],
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
            style: Theme.of(
              context,
            ).textTheme.bodySmall,
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

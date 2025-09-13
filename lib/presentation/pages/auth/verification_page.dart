import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/data/models/auth/auth_params.dart';
import 'package:hub_dom/presentation/bloc/auth_bloc/user_auth_bloc.dart';
import 'package:hub_dom/presentation/bloc/otp_cubit/otp_cubit.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/otp_timer/otp_timer_bloc.dart';
import 'package:hub_dom/presentation/widgets/error_widget.dart';
import 'package:pinput/pinput.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key, required this.params});

  final LoginParams params;

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final timerBloc = locator<OtpTimerBloc>();
  final otpCubit = locator<OtpCubit>();

  String? code;
  String? session;

  bool validate() {
    // Run form validators first
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return false;
    if (code == null || session == null) return false;

    final pinNumber = pinController.text.trim();

    return pinNumber == code;
  }

  @override
  void initState() {
    super.initState();
    code = widget.params.code;
    session = widget.params.session;
    timerBloc.add(OtpTimerStartedEvent(minutes: 1, seconds: 00));
    pinController.addListener(disableButton);
    locator<UserAuthBloc>().add(InitialEvent());


  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool disableButton() {
    if (pinController.text == code) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> reset() async {
    timerBloc.add(OtpTimerStartedEvent(minutes: 1, seconds: 00));
    final int? phoneNumber = int.tryParse(widget.params.phoneNumber);
    if (phoneNumber != null) {
      otpCubit.sendOtp(phoneNumber);

      // wait for the next OtpLoaded state
      final otpState = await otpCubit.stream.firstWhere((s) => s is OtpLoaded) as OtpLoaded;

      setState(() {
        code = otpState.data.code;
        session = otpState.data.session;
      });
      locator<UserAuthBloc>().add(InitialEvent());
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
                  '${AppStrings.verificationSend} +7${widget.params.phoneNumber}',

                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 40),

              BlocBuilder<UserAuthBloc, UserAuthState>(
                builder: (context, userState) {
                  if (userState is UserAuthFailure) {
                    return KErrorWidget(onTap: reset);
                  }
                  return Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Pinput(
                            length: 4,
                            controller: pinController,
                            focusNode: focusNode,
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            defaultPinTheme: defaultPinTheme,
                            separatorBuilder: (index) =>
                                const SizedBox(width: 12),
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            onCompleted: (pin) {
                              debugPrint('onCompleted: $pin');
                            },
                            validator: (s) {
                              return s == code
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
                            errorTextStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.red),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      BlocProvider.value(
                        value: timerBloc,
                        child: BlocConsumer<OtpTimerBloc, OtpTimerState>(
                          listener: (context, state) {
                            if (state is OtpTimeOver) {

                             setState(() {
                               code = null;
                               session = null;

                             });
                            }
                          },
                          builder: (context, state) {
                            if (state is OtpTimeOver) {
                              return TextButton(
                                onPressed: reset,
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
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      BlocConsumer<UserAuthBloc, UserAuthState>(
                        listener: (context, state) {
                          if (state is UserAuthenticated) {
                            context.go(AppRoutes.applications);
                          }
                        },
                        builder: (context, state) {
                          return MainButton(
                            buttonTile: AppStrings.confirm,
                            onPressed: () async {
                              final String pinNumber = pinController.text
                                  .trim();
                              final String phoneNumber =
                                  widget.params.phoneNumber;

                              final params = LoginParams(
                                session: session ?? widget.params.session,
                                code: pinNumber,
                                phoneNumber: phoneNumber,
                              );
                              log(params.toString(), name: 'login');
                              if (validate()) {
                                context.read<UserAuthBloc>().add(
                                  LogInEvent(params),
                                );
                              }
                            },
                            isLoading: state is UserAuthLoading,
                            isDisable: disableButton(),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

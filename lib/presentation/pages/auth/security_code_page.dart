import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/data/models/auth/set_profile_params.dart';
import 'package:hub_dom/presentation/bloc/set_profile/set_profile_cubit.dart';
import 'package:hub_dom/presentation/bloc/is_responsible/is_responsible_cubit.dart';
import 'package:hub_dom/presentation/bloc/crm_system/crm_system_cubit.dart';
import 'package:hub_dom/presentation/bloc/selected_crm/selected_crm_cubit.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:pinput/pinput.dart';

class SecurityCodePage extends StatefulWidget {
  const SecurityCodePage({
    super.key, // required this.params
  });

  //final LoginParams params;

  @override
  State<SecurityCodePage> createState() => _SecurityCodePageState();
}

class _SecurityCodePageState extends State<SecurityCodePage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  //String? code;
  bool showChangeButton = false;
  bool _hasNavigated = false; // Флаг для предотвращения повторной навигации

  bool validate() {
    // Run form validators first
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return false;
    //if (code == null) return false;

    final pinNumber = pinController.text.trim();

    return pinNumber.length == 4;
  }

  @override
  void initState() {
    super.initState();
    // code = widget.params.code;
    pinController.addListener(disableButton);
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
                  AppStrings.enterCode,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  AppStrings.enter4Digit,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 40),

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
                        },
                        validator: (s) {
                          //   showChangeButton = s != code;
                          return s != null && s.isNotEmpty
                              ? null
                              : AppStrings.wrongVerification;
                        },
                        onChanged: (value) {
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
                  if (showChangeButton) SizedBox(height: 40),
                  if (showChangeButton)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          pinController.clear();
                        });
                      },
                      child: Text(
                        AppStrings.changePassword,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  SizedBox(height: 40),

                  // Слушаем загрузку CRM систем и устанавливаем токен, затем проверяем isResponsible
                  BlocListener<CrmSystemCubit, CrmSystemState>(
                    listener: (context, state) async {
                      if (state is CrmSystemLoaded && state.data.isNotEmpty) {
                        // Если есть CRM системы, устанавливаем первую (индекс 0)
                        final selectedCrmCubit = locator<SelectedCrmCubit>();
                        await selectedCrmCubit.setCrmSystem(0);
                      }
                    },
                    child: const SizedBox.shrink(),
                  ),
                  // Слушаем установку CRM токена и проверяем isResponsible
                  BlocListener<SelectedCrmCubit, SelectedCrmState>(
                    listener: (context, state) async {
                      if (state is SelectedCrmLoaded && !_hasNavigated) {
                        _hasNavigated = true; // Предотвращаем повторную навигацию
                        
                        // После установки CRM токена проверяем isResponsible
                        final isResponsibleCubit = locator<IsResponsibleCubit>();
                        await isResponsibleCubit.checkIsResponsible();
                        
                        if (!mounted) return;
                        
                        // Получаем результат и переходим на правильную страницу
                        final currentState = isResponsibleCubit.state;
                        bool isResponsible = false;
                        
                        debugPrint('[SecurityCodePage] Current state type: ${currentState.runtimeType}');
                        
                        if (currentState is IsResponsibleLoaded) {
                          isResponsible = currentState.isResponsible;
                          debugPrint('[SecurityCodePage] isResponsible from state: $isResponsible');
                        } else if (currentState is IsResponsibleError) {
                          // При ошибке (например, 404) считаем, что пользователь не ответственный
                          isResponsible = false;
                          debugPrint('[SecurityCodePage] Error state, defaulting to false');
                        } else {
                          debugPrint('[SecurityCodePage] Unexpected state, defaulting to false');
                        }
                        
                        debugPrint('[SecurityCodePage] Final isResponsible: $isResponsible (after CRM token set)');
                        
                        // Переходим на правильную страницу после завершения текущего кадра
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          
                          // Переходим на правильную страницу
                          // isResponsible = true → руководитель → applications (страница со статистикой)
                          // isResponsible = false → обычный сотрудник → organizations
                          if (isResponsible) {
                            debugPrint('[SecurityCodePage] → Navigating to applications (руководитель)');
                            context.go(AppRoutes.applications);
                          } else {
                            debugPrint('[SecurityCodePage] → Navigating to organizations (обычный сотрудник)');
                            context.go(AppRoutes.organizations);
                          }
                        });
                      }
                    },
                    child: const SizedBox.shrink(),
                  ),

                  //todo change bloc
                  BlocConsumer<SetProfileCubit, SetProfileState>(
                    listener: (context, state) async {
                      if (state is SetProfileLoaded) {
                        // После успешного SetProfile загружаем CRM системы
                        final crmSystemCubit = locator<CrmSystemCubit>();
                        await crmSystemCubit.getCrmSystems();
                      }
                    },
                    builder: (context, state) {
                      return MainButton(
                        buttonTile: AppStrings.confirm,
                        onPressed: () async {
                          final String pinNumber = pinController.text.trim();

                          final params = SetProfileParams(
                            securityCode: pinNumber,
                            securityCodeConfirm: pinNumber,
                          );

                          if (validate()) {
                            context.read<SetProfileCubit>().setProfile(params);
                          }
                        },
                        isLoading: state is SetProfileLoading,
                        isDisable: disableButton(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

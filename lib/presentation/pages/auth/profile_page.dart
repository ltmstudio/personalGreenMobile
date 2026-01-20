import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/data/models/auth/crm_system_model.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/auth_bloc/user_auth_bloc.dart';
import 'package:hub_dom/presentation/bloc/crm_system/crm_system_cubit.dart';
import 'package:hub_dom/presentation/bloc/selected_crm/selected_crm_cubit.dart';
import 'package:hub_dom/presentation/bloc/set_profile/set_profile_cubit.dart';
import 'package:hub_dom/presentation/widgets/appbar_icon.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/gray_loading_indicator.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';

import '../../../core/local/token_store.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final SetProfileCubit _profileCubit;
  late final CrmSystemCubit _crmCubit;

  bool _isResponsible = true;
  int? _selectedCrmId;
  bool _switching = false;

  @override
  void initState() {
    super.initState();

    _profileCubit = locator<SetProfileCubit>();
    _crmCubit = locator<CrmSystemCubit>();
    _initLocalState();
    _profileCubit.getProfile();
    _crmCubit.getCrmSystems();
  }

  Future<void> _initLocalState() async {
    final store = locator<Store>();
    final isResp = await store.getIsResponsible() ?? false;
    final selectedId = await store.getSelectedCrmId();

    if (!mounted) return;
    setState(() {
      _isResponsible = isResp;
      _selectedCrmId = selectedId;
    });
  }

  Future<void> _switchOrganization(CrmSystemModel model) async {
    if (_switching) return;
    setState(() => _switching = true);

    try {
      // 1) сохраняем host/name/token + selectedCrmId
      await locator<SelectedCrmCubit>().setCrmSystemByModel(model);

      final selectedId = await locator<Store>().getSelectedCrmId();
      if (!mounted) return;

      setState(() => _selectedCrmId = selectedId);

      // 2) переходим в details (ВАЖНО: details должен уметь открыться без extra или мы передаем model)
      context.go(
        '${AppRoutes.organizations}/organizationDetails',
        extra: {'model': model},
      );
    } finally {
      if (mounted) setState(() => _switching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SetProfileCubit>.value(value: _profileCubit),
        BlocProvider<CrmSystemCubit>.value(value: _crmCubit),
      ],
      child: BlocBuilder<SetProfileCubit, SetProfileState>(
        builder: (context, state) {
          if (state is SetProfileLoading || state is SetProfileInitial) {
            return _baseScaffold(
              title: 'Профиль',
              body: const Center(child: GrayLoadingIndicator()),
            );
          }

          if (state is SetProfileError || state is SetProfileConnectionError) {
            return _baseScaffold(
              title: 'Профиль',
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ошибка загрузки профиля',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _profileCubit.getProfile(),
                      child: Text(AppStrings.repeat),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is SetProfileLoaded) {
            final displayName = state.data.fullName?.isNotEmpty == true
                ? state.data.fullName!
                : (state.data.userName.isNotEmpty
                      ? state.data.userName
                      : (state.data.name?.isNotEmpty == true
                            ? state.data.name!
                            : 'Пользователь'));

            final jobTitle = state.data.position?.isNotEmpty == true
                ? state.data.position!
                : null;
            final phone = state.data.phone?.isNotEmpty == true
                ? state.data.phone!
                : null;
            final email = state.data.email?.isNotEmpty == true
                ? state.data.email!
                : null;

            return Scaffold(
              appBar: AppBar(
                title: Text(displayName),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, top: 10),
                    child: AppBarIcon(
                      icon: IconAssets.logout,
                      onTap: () => _logout(context),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    child: MainCardWidget(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFieldTitle(
                            title: AppStrings.jobTitle,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(jobTitle ?? 'Не указано'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFieldTitle(
                            title: AppStrings.phone,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(phone ?? 'Не указано'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFieldTitle(
                            title: AppStrings.email,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(email ?? 'Не указано'),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: BlocBuilder<CrmSystemCubit, CrmSystemState>(
                      builder: (context, crmState) {
                        log(crmState.toString(), name: 'crmState');

                        if (crmState is CrmSystemLoading) {
                          return const Center(child: GrayLoadingIndicator());
                        }

                        if (crmState is CrmSystemEmpty) {
                          return Center(child: Text(AppStrings.empty));
                        }

                        if (crmState is CrmSystemConnectionError) {
                          return Center(child: Text(AppStrings.noInternet));
                        }

                        if (crmState is CrmSystemError) {
                          return Center(child: Text(AppStrings.error));
                        }

                        if (crmState is CrmSystemLoaded) {
                          final list = crmState.data;

                          // ВАЖНО: показываем список даже если 1 элемент
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final item = list[index].crm;
                              final isSelected =
                                  _selectedCrmId != null &&
                                  item.id == _selectedCrmId;

                              return Opacity(
                                opacity: _isResponsible ? 0.6 : 1.0,

                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: _isResponsible || _switching
                                      ? null
                                      : () => _showSwitchOrgSheet(list[index]),

                                  child: MainCardWidget(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.name,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isSelected && !_isResponsible)
                                          Icon(
                                            Icons.check_circle,
                                            color: isSelected
                                                ? AppColors.green
                                                : AppColors.gray,
                                          ),
                                        const SizedBox(width: 8),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.timeColor,
                                          ),
                                          child: SvgPicture.asset(
                                            IconAssets.house,
                                            semanticsLabel: 'Организация',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                          );
                        }

                        return Center(child: Text(AppStrings.error));
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return _baseScaffold(
            title: 'Профиль',
            body: const Center(child: GrayLoadingIndicator()),
          );
        },
      ),
    );
  }

  Widget _baseScaffold({required String title, required Widget body}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 10),
            child: AppBarIcon(
              icon: IconAssets.logout,
              onTap: () => _logout(context),
            ),
          ),
        ],
      ),
      body: body,
    );
  }

  Future<void> _showSwitchOrgSheet(CrmSystemModel model) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor:
       Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (ctx) {
        return _SwitchOrgConfirmSheet(
          onConfirm: () => Navigator.of(ctx).pop(true),
          onClose: () => Navigator.of(ctx).pop(false),
        );
      },
    );




    if (confirmed == true) {
      await _switchOrganization(model);
    }
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 24,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    AppStrings.confirmExit,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppStrings.confirmLogout,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: AppColors.lightGray, thickness: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text(
                            AppStrings.cancel,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: AppColors.lightGray,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            locator<UserAuthBloc>().add(LogOutEvent());
                            context.go(AppRoutes.splash);
                          },
                          child: const Text(
                            AppStrings.logout,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   void initState() {
//     super.initState();
//     // Загружаем профиль при открытии страницы
//     locator<SetProfileCubit>().getProfile();
//     locator<CrmSystemCubit>().getCrmSystems();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SetProfileCubit, SetProfileState>(
//       bloc: locator<SetProfileCubit>(),
//       builder: (context, state) {
//         // Показываем индикатор загрузки, пока данные не загружены
//         if (state is SetProfileLoading || state is SetProfileInitial) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Профиль'),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 15.0, top: 10),
//                   child: AppBarIcon(
//                     icon: IconAssets.logout,
//                     onTap: () {
//                       _logout(context);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             body: const Center(child: GrayLoadingIndicator()),
//           );
//         }
//
//         // Показываем ошибку, если загрузка не удалась
//         if (state is SetProfileError || state is SetProfileConnectionError) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Профиль'),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 15.0, top: 10),
//                   child: AppBarIcon(
//                     icon: IconAssets.logout,
//                     onTap: () {
//                       _logout(context);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Ошибка загрузки профиля',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       locator<SetProfileCubit>().getProfile();
//                     },
//                     child: Text(AppStrings.repeat),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         // Показываем данные только когда они загружены
//         if (state is SetProfileLoaded) {
//           // Формируем отображаемое имя с fallback значениями
//           final displayName = state.data.fullName?.isNotEmpty == true
//               ? state.data.fullName!
//               : (state.data.userName.isNotEmpty
//                     ? state.data.userName
//                     : (state.data.name?.isNotEmpty == true
//                           ? state.data.name!
//                           : 'Пользователь'));
//
//           final jobTitle = state.data.position?.isNotEmpty == true
//               ? state.data.position!
//               : null;
//           final phone = state.data.phone?.isNotEmpty == true
//               ? state.data.phone!
//               : null;
//           final email = state.data.email?.isNotEmpty == true
//               ? state.data.email!
//               : null;
//
//           return Scaffold(
//             appBar: AppBar(
//               title: Text(displayName),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 15.0, top: 10),
//                   child: AppBarIcon(
//                     icon: IconAssets.logout,
//                     onTap: () {
//                       _logout(context);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             body: Column(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   margin: EdgeInsets.all(20),
//                   child: MainCardWidget(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         TextFieldTitle(
//                           title: AppStrings.jobTitle,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 5),
//                             child: Text(jobTitle ?? 'Не указано'),
//                           ),
//                         ),
//                         SizedBox(height: 12),
//                         TextFieldTitle(
//                           title: AppStrings.phone,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 5),
//                             child: Text(phone ?? 'Не указано'),
//                           ),
//                         ),
//                         SizedBox(height: 12),
//                         TextFieldTitle(
//                           title: AppStrings.email,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 5),
//                             child: Text(email ?? 'Не указано'),
//                           ),
//                         ),
//                         SizedBox(height: 12),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 Expanded(child: BlocBuilder<CrmSystemCubit, CrmSystemState>(
//                   builder: (context, state) {
//                     log(state.toString(),name: 'myState');
//                     if (state is CrmSystemLoaded && state.data.length > 1) {
//                       return ListView.separated(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                         itemCount: state.data.length,
//                         itemBuilder: (context, index) {
//                           final item = state.data[index].crm;
//
//                           return InkWell(
//                             borderRadius: BorderRadius.circular(12),
//                             onTap: () {
//                               // locator<SelectedCrmCubit>().setCrmSystem(index);
//                               // context.go(
//                               //   '${AppRoutes.organizations}/organizationDetails',
//                               //   extra: {'model': state.data[index]},
//                               // );
//                             },
//                             child: MainCardWidget(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     item.name,
//                                     style: Theme.of(context).textTheme.titleMedium,
//                                   ),
//                                   Container(
//                                     height: 40,
//                                     width: 40,
//                                     alignment: Alignment.center,
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: AppColors.timeColor,
//                                     ),
//                                     child: SvgPicture.asset(
//                                       IconAssets.house,
//                                       semanticsLabel: 'Организация',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                         separatorBuilder: (context, index) => const SizedBox(height: 12),
//                       );
//                     } else if (state is CrmSystemLoading) {
//                       return Center(
//                         child: const GrayLoadingIndicator(),
//                       );
//                     } else if (state is CrmSystemEmpty) {
//                       return Center(child: Text(AppStrings.empty));
//                     } else if (state is CrmSystemConnectionError) {
//                       return Center(child: Text(AppStrings.noInternet));
//                     } else {
//                       return Center(child: Text(AppStrings.error));
//                     }
//                   },
//                 ))
//
//               ],
//             ),
//           );
//         }
//
//         // Fallback на случай, если состояние не распознано
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Профиль'),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 15.0, top: 10),
//                 child: AppBarIcon(
//                   icon: IconAssets.logout,
//                   onTap: () {
//                     _logout(context);
//                   },
//                 ),
//               ),
//             ],
//           ),
//           body: const Center(child: GrayLoadingIndicator()),
//         );
//       },
//     );
//   }
//
//   _logout(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           insetPadding: const EdgeInsets.symmetric(
//             horizontal: 30,
//             vertical: 24,
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                   child: const Text(
//                     AppStrings.confirmExit,
//                     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Text(
//                     AppStrings.confirmLogout,
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Divider(color: AppColors.lightGray, thickness: 1),
//
//                 // Cancel + Logout buttons
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: TextButton(
//                           onPressed: () {
//                             Navigator.of(ctx).pop();
//                           },
//                           child: Text(
//                             AppStrings.cancel,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 17,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: 50,
//                         width: 1,
//                         color: AppColors.lightGray,
//                       ),
//                       Expanded(
//                         child: TextButton(
//                           onPressed: () {
//                             locator<UserAuthBloc>().add(LogOutEvent());
//                             context.go(AppRoutes.splash);
//                           },
//                           child: Text(
//                             AppStrings.logout,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 17,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
class _SwitchOrgConfirmSheet extends StatelessWidget {
  const _SwitchOrgConfirmSheet({
    required this.onConfirm,
    required this.onClose,
  });

  final VoidCallback onConfirm;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Сменить организацию?',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'При переключении организации список заявок будет обновлен автоматически. '
              'Вы будете видеть только заявки, относящиеся к выбранной организации.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            MainButton(buttonTile: 'Сменить организацию', onPressed: onConfirm, isLoading: false)

          ],
        ),
      ),
    );
  }
}

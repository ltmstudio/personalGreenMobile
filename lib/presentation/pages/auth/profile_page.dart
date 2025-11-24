import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/auth_bloc/user_auth_bloc.dart';
import 'package:hub_dom/presentation/bloc/set_profile/set_profile_cubit.dart';
import 'package:hub_dom/presentation/widgets/appbar_icon.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Загружаем профиль при открытии страницы
    locator<SetProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetProfileCubit, SetProfileState>(
      bloc: locator<SetProfileCubit>(),
      builder: (context, state) {
        // Показываем индикатор загрузки, пока данные не загружены
        if (state is SetProfileLoading || state is SetProfileInitial) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Профиль'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 10),
                  child: AppBarIcon(
                    icon: IconAssets.logout,
                    onTap: () {
                      _logout(context);
                    },
                  ),
                ),
              ],
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Показываем ошибку, если загрузка не удалась
        if (state is SetProfileError || state is SetProfileConnectionError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Профиль'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 10),
                  child: AppBarIcon(
                    icon: IconAssets.logout,
                    onTap: () {
                      _logout(context);
                    },
                  ),
                ),
              ],
            ),
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
                    onPressed: () {
                      locator<SetProfileCubit>().getProfile();
                    },
                    child: Text(AppStrings.repeat),
                  ),
                ],
              ),
            ),
          );
        }

        // Показываем данные только когда они загружены
        if (state is SetProfileLoaded) {
          final userName = state.data.fullName ?? state.data.userName;
          final jobTitle = state.data.position;
          final phone = state.data.phone;
          final email = state.data.email;

          return Scaffold(
            appBar: AppBar(
              title: Text(userName),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 10),
                  child: AppBarIcon(
                    icon: IconAssets.logout,
                    onTap: () {
                      _logout(context);
                    },
                  ),
                ),
              ],
            ),
            body: Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
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
                    SizedBox(height: 12),
                    TextFieldTitle(
                      title: AppStrings.phone,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(phone ?? 'Не указано'),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFieldTitle(
                      title: AppStrings.email,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(email ?? 'Не указано'),
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          );
        }

        // Fallback на случай, если состояние не распознано
        return Scaffold(
          appBar: AppBar(
            title: const Text('Профиль'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0, top: 10),
                child: AppBarIcon(
                  icon: IconAssets.logout,
                  onTap: () {
                    _logout(context);
                  },
                ),
              ),
            ],
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  _logout(BuildContext context) {
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: const Text(
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
                Divider(color: AppColors.lightGray, thickness: 1),

                // Cancel + Logout buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text(
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
                            locator<UserAuthBloc>().add(LogOutEvent());
                            context.go(AppRoutes.splash);
                          },
                          child: Text(
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

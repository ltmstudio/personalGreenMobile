import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/crm_system/crm_system_cubit.dart';
import 'package:hub_dom/presentation/bloc/selected_crm/selected_crm_cubit.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  final crmSystemCubit = locator<CrmSystemCubit>();

  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    crmSystemCubit.getCrmSystems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.organizations)),
      body: BlocConsumer<CrmSystemCubit, CrmSystemState>(
        listener: (BuildContext context, CrmSystemState state) {
          if (state is CrmSystemLoaded &&
              state.data.length == 1 &&
              !_navigated) {
            _navigated = true;
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   if (mounted) {
            //     locator<SelectedCrmCubit>().setCrmSystem(0);
            //     context.go(
            //       AppRoutes.organizationDetails,
            //       extra: {'model': state.data.first},
            //     );
            //   }
            // });
            locator<SelectedCrmCubit>().setCrmSystem(0);
            context.go(
              '${AppRoutes.organizations}/organizationDetails',
              extra: {'model': state.data.first},
            );
          }
        },
        builder: (context, state) {
          if (state is CrmSystemLoaded && state.data.length > 1) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final item = state.data[index].crm;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    locator<SelectedCrmCubit>().setCrmSystem(index);
                    context.go(
                      '${AppRoutes.organizations}/organizationDetails',
                      extra: {'model': state.data[index]},
                    );
                  },
                  child: MainCardWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
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
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            );
          } else if (state is CrmSystemLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CrmSystemEmpty) {
            return Center(child: Text(AppStrings.empty));
          } else if (state is CrmSystemConnectionError) {
            return Center(child: Text(AppStrings.noInternet));
          } else {
            return Center(child: Text(AppStrings.error));
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/utils/color_utils.dart';
import 'package:hub_dom/presentation/bloc/application_details/application_details_bloc.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/selectable_btn.dart';
import 'package:hub_dom/presentation/widgets/gray_loading_indicator.dart';

import 'components/employee_app.dart';
import 'components/employee_report.dart';

class EmployeeAppDetailsPage extends StatefulWidget {
  const EmployeeAppDetailsPage({super.key, required this.title, this.ticketId});

  final String title;
  final int? ticketId;

  @override
  State<EmployeeAppDetailsPage> createState() => _EmployeeAppDetailsPageState();
}

class _EmployeeAppDetailsPageState extends State<EmployeeAppDetailsPage> {
  final statuses = AppStrings.statuses;
  int index = 0;

  Future<void> _handleBack() async {
    // Use the context of the page, not the bottom sheet
    final shouldPop = await showConfirmBack(context);
    if (shouldPop) {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = GetIt.instance<ApplicationDetailsBloc>();
        if (widget.ticketId != null) {
          bloc.add(LoadTicketDetailsEvent(widget.ticketId!));
        }
        return bloc;
      },
      child: BlocBuilder<ApplicationDetailsBloc, ApplicationDetailsState>(
        builder: (context, state) {
          String? statusTitle;
          Color statusColor = AppColors.yellow;
          Color statusFontColor = Colors.white;
          if (state is ApplicationDetailsLoaded) {
            statusTitle = state.ticket.data?.status?.title;
            if (state.ticket.data?.status?.color != null) {
              statusColor = ColorUtils.hexToColor(
                state.ticket.data!.status!.color!,
              );
            }
            if (state.ticket.data?.status?.fontColor != null) {
              statusFontColor = ColorUtils.hexToColor(
                state.ticket.data!.status!.fontColor!,
              );
            }
          }

          final ticketData = state is ApplicationDetailsLoaded
              ? state.ticket.data
              : null;

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              await _handleBack();
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _handleBack,
                ),
                actions: [
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(34),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            statusTitle ?? AppStrings.control,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: statusFontColor),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.check_circle_outline_sharp,
                            size: 18,
                            color: statusFontColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SelectableBtn(
                          isSelected: index == 0,
                          title: AppStrings.application,
                          onTap: () {
                            setState(() {
                              index = 0;
                            });
                          },
                        ),
                        SizedBox(width: 5),
                        SelectableBtn(
                          isSelected: index == 1,
                          title: AppStrings.report,
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: _buildBody(context, state, ticketData),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ApplicationDetailsState state,
    dynamic ticketData,
  ) {
    if (state is ApplicationDetailsLoading) {
      return Center(child: const GrayLoadingIndicator());
    }

    if (state is ApplicationDetailsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ошибка: ${state.message}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (widget.ticketId != null) {
                  context.read<ApplicationDetailsBloc>().add(
                    LoadTicketDetailsEvent(widget.ticketId!),
                  );
                }
              },
              child: Text('Повторить'),
            ),
          ],
        ),
      );
    }

    return index == 0
        ? EmployeeAppsPage(ticketData: ticketData)
        : EmployeeReportPage(ticketId: widget.ticketId);
  }
}

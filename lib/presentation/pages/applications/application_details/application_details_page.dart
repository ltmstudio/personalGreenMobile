import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/utils/color_utils.dart';
import 'package:hub_dom/presentation/bloc/application_details/application_details_bloc.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/report_page.dart';
import 'package:hub_dom/data/models/employees/get_employee_response_model.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/performer_widget.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/selectable_btn.dart';
import 'package:hub_dom/presentation/widgets/confirm_bottomsheet.dart';
import 'package:hub_dom/presentation/widgets/gray_loading_indicator.dart';
import 'package:hub_dom/presentation/widgets/toast_widget.dart';

import 'apps_page.dart';

class ApplicationDetailsPage extends StatefulWidget {
  final int? ticketId;

  const ApplicationDetailsPage({super.key, this.ticketId});

  @override
  State<ApplicationDetailsPage> createState() => _ApplicationDetailsPageState();
}

class _ApplicationDetailsPageState extends State<ApplicationDetailsPage> {
  final statuses = AppStrings.statuses;
  int index = 0;
  String? selectedPerformer;
  String? selectedContact;
  int? selectedExecutorId;
  Employee?
  _pendingEmployee; // Временно сохраненный исполнитель до успешного ответа

  @override
  void initState() {
    super.initState();
    selectedPerformer = null;
  }

  @override
  void dispose() {
    super.dispose();
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
      child: BlocListener<ApplicationDetailsBloc, ApplicationDetailsState>(
        listener: (context, state) {
          if (state is ApplicationDetailsLoaded) {
            // При загрузке заявки устанавливаем данные исполнителя и контактного лица
            final ticketData = state.ticket.data;
            setState(() {
              // Устанавливаем исполнителя из данных заявки
              if (ticketData?.executor != null) {
                selectedExecutorId = ticketData!.executor!.id;
                selectedPerformer = ticketData.executor!.fullName;
              } else if (ticketData?.executorId != null) {
                selectedExecutorId = ticketData!.executorId;
                selectedPerformer =
                    null; // Если нет объекта executor, но есть ID
              } else {
                selectedExecutorId = null;
                selectedPerformer = null;
              }

              // Устанавливаем контактное лицо из данных заявки
              if (ticketData?.resident != null) {
                // Если resident - это строка
                if (ticketData!.resident is String) {
                  selectedContact = ticketData.resident as String;
                } else if (ticketData.resident is Map) {
                  // Если resident - это объект, пытаемся извлечь имя
                  final residentMap = ticketData.resident as Map;
                  selectedContact =
                      residentMap['full_name'] ??
                      residentMap['name'] ??
                      residentMap.toString();
                }
              } else {
                selectedContact = null;
              }
            });
          } else if (state is ApplicationDetailsExecutorAssigned) {
            // Закрываем bottom sheet после успешного назначения исполнителя
            Navigator.of(context).pop();
            Toast.show(context, 'Исполнитель назначен');
            // Применяем выбранного исполнителя только после успешного ответа
            if (_pendingEmployee != null) {
              setState(() {
                selectedExecutorId = _pendingEmployee!.id;
                selectedPerformer = _pendingEmployee!.fullName;
                selectedContact = _pendingEmployee!.fullName;
                _pendingEmployee = null;
              });
            }
          } else if (state is ApplicationDetailsError) {
            // Показываем понятное сообщение об ошибке
            Toast.show(context, state.message);
            // Сбрасываем выбранного исполнителя и текстовое поле при ошибке
            // только если это не ошибка загрузки (чтобы не сбросить уже загруженные данные)
            if (state.message.contains('загрузк') ||
                state.message.contains('load') ||
                state.message.contains('404') ||
                state.message.contains('500')) {
              setState(() {
                selectedExecutorId = null;
                selectedPerformer = null;
                selectedContact = null;
                _pendingEmployee = null;
              });
            } else {
              // Для других ошибок сбрасываем только pending
              _pendingEmployee = null;
            }
          }
        },
        child: BlocBuilder<ApplicationDetailsBloc, ApplicationDetailsState>(
          builder: (context, state) {
            String title = 'Заявка';
            String? statusTitle;
            Color statusColor = AppColors.yellow;
            Color statusFontColor = Colors.white;
            if (state is ApplicationDetailsLoaded) {
              title = 'Заявка №${state.ticket.data?.id ?? ''}';
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
            } else if (widget.ticketId != null) {
              title = 'Заявка №${widget.ticketId}';
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(title),
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

              body: _buildBody(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ApplicationDetailsState state) {
    if (state is ApplicationDetailsLoading) {
      return Center(child: const GrayLoadingIndicator());
    }

    // Показываем экран ошибки только при ошибке загрузки данных
    // Для ошибок операций (accept/reject/assign) показываем предыдущее состояние
    // которое эмитится сразу после ошибки, поэтому эта проверка сработает
    // только для ошибок загрузки
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

    final ticketData = state is ApplicationDetailsLoaded
        ? state.ticket.data
        : null;

    final bloc = context.read<ApplicationDetailsBloc>();

    return index == 0
        ? AppsPage(
            ticketData: ticketData,
            selectedPerformer: selectedPerformer,
            selectedContact: selectedContact,
            selectedExecutorId: selectedExecutorId,
            onShowPerformer: () => _showPerformer(context, bloc),
            onShowContact: () => _showPerformer(context, bloc),
          )
        : AppDetailsReportPage(
            ticketData: ticketData,
            selectedExecutorId: selectedExecutorId,
            ticketId: widget.ticketId,
          );
  }

  void _showPerformer(BuildContext context, ApplicationDetailsBloc bloc) {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: BlocProvider.value(
        value: bloc,
        child: PerformerWidget(
          onSelectItem: (String value) {
            setState(() {
              selectedPerformer = value;
              selectedContact = value;
            });
          },
          onSelectEmployee: (Employee employee) {
            // PerformerWidget уже закрывает bottom sheet при isSelected == true
            // Показываем диалог подтверждения после небольшой задержки
            // чтобы bottom sheet успел закрыться
            Future.microtask(() {
              if (mounted) {
                _showAssignExecutorDialog(context, bloc, employee);
              }
            });
          },
          isSelected: true,
        ),
      ),
    );
  }

  void _showAssignExecutorDialog(
    BuildContext context,
    ApplicationDetailsBloc bloc,
    Employee employee,
  ) {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: BlocProvider.value(
        value: bloc,
        child: ConfirmBottomSheet(
          title: 'Назначить исполнителя?',
          body: 'Заявка будет назначена на выбранного исполнителя',
          confirmButtonText: AppStrings.assign,
          cancelButtonText: 'Закрыть',
          onTap: () {
            // Сохраняем выбранного исполнителя во временную переменную
            // Применим его только после успешного ответа
            setState(() {
              _pendingEmployee = employee;
            });
            // Вызываем assignExecutor после подтверждения
            if (widget.ticketId != null && employee.id != null) {
              bloc.add(
                AssignExecutorEvent(
                  ticketId: widget.ticketId!,
                  executorId: employee.id!,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

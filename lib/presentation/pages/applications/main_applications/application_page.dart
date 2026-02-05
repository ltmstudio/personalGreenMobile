import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/utils/date_time_utils.dart';
import 'package:hub_dom/data/models/tickets/ticket_response_model.dart';
import 'package:hub_dom/data/models/employees/get_employee_response_model.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_event.dart';
import 'package:hub_dom/presentation/bloc/tickets/tickets_bloc.dart';
import 'package:hub_dom/presentation/bloc/employees/employees_bloc.dart';
import 'package:hub_dom/presentation/widgets/appbar_icon.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/search_btn.dart';
import 'package:hub_dom/presentation/widgets/cards/employee_card.dart';
import 'package:hub_dom/presentation/widgets/cards/object_card.dart';
import 'package:hub_dom/presentation/widgets/cards/stat_card.dart';
import 'package:hub_dom/presentation/widgets/filter_widget.dart';
import 'package:hub_dom/presentation/widgets/gray_loading_indicator.dart';

import '../../../../data/models/addresses/addresses_response_model.dart';
import '../../../bloc/addresses/addresses_bloc.dart';
import '../../../bloc/addresses/addresses_state.dart';
import 'components/address_widget.dart';
import 'components/performer_widget.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  late final TicketsBloc _ticketsBloc;
  late final EmployeesBloc _employeesBloc;
  DateTimeRange<DateTime>? selectedDate;
  String? selectedAddress;
  String? selectedPerformer;

  @override
  void initState() {
    super.initState();
    _ticketsBloc = locator<TicketsBloc>();
    _employeesBloc = locator<EmployeesBloc>();
    context.read<AddressesBloc>().add(LoadAddressesEvent());
    // Загружаем все заявки без фильтров для дашборда
    _loadTickets();
    // Загружаем сотрудников со статистикой
    _loadEmployees();
    clear();
  }

  /// Загружает сотрудников со статистикой
  void _loadEmployees() {
    _employeesBloc.add(
      const LoadEmployeesEvent(page: 1, perPage: 20, withStatistics: true),
    );
  }

  /// Загружает заявки с учетом текущих фильтров
  void _loadTickets() {
    String? startDate;
    String? endDate;

    if (selectedDate != null) {
      startDate = DateTimeUtils.formatDateForApi(selectedDate!.start);
      endDate = DateTimeUtils.formatDateForApi(selectedDate!.end);
    }

    _ticketsBloc.add(
      LoadTicketsEvent(
        startDate: startDate,
        endDate: endDate,
        page: 1,
        perPage: 1000,
      ),
    );
  }

  @override
  void dispose() {
    _ticketsBloc.close();
    _employeesBloc.close();
    super.dispose();
  }

  clear() {
    selectedAddress = null;
    selectedPerformer = null;
    selectedDate = null;
    setState(() {});
  }

  /// Рассчитывает статистику из данных API
  Map<String, dynamic> _calculateStats(
    List<Ticket> tickets,
    List<Stat> apiStats,
  ) {
    final total = tickets.length;

    // Получаем ВСЕ данные только из API stats
    int handleExecutor = 0;
    int inProgress = 0;
    int approval = 0;
    int control = 0;
    int done = 0;

    for (final stat in apiStats) {
      switch (stat.name) {
        case 'handle_executor':
          handleExecutor = stat.count ?? 0;
          break;
        case 'in_progress':
          inProgress = stat.count ?? 0;
          break;
        case 'approval':
          approval = stat.count ?? 0;
          break;
        case 'control':
          control = stat.count ?? 0;
          break;
        case 'done':
          done = stat.count ?? 0;
          break;
      }
    }

    return {
      'total': total,
      'handleExecutor': handleExecutor,
      'inProgress': inProgress,
      'approval': approval,
      'control': control,
      'done': done,
      'handleExecutorPercent': total > 0
          ? ((handleExecutor / total) * 100).toStringAsFixed(0)
          : '0',
      'inProgressPercent': total > 0
          ? ((inProgress / total) * 100).toStringAsFixed(0)
          : '0',
      'approvalPercent': total > 0
          ? ((approval / total) * 100).toStringAsFixed(0)
          : '0',
      'controlPercent': total > 0
          ? ((control / total) * 100).toStringAsFixed(0)
          : '0',
      'donePercent': total > 0
          ? ((done / total) * 100).toStringAsFixed(0)
          : '0',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.applications),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 10),
            child: AppBarIcon(
              icon: IconAssets.scanner,
              onTap: () {
                context.push(AppRoutes.scanner);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 8.0, top: 10),
            child: AppBarIcon(
              icon: IconAssets.filter,
              onTap: _showFilter,
              showIndicator: selectedDate != null,
              indicatorValue: selectedDate != null ? 1 : null,
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 8),
        child: FloatingActionButton(
          backgroundColor: AppColors.green,
          onPressed: () {
            context.push(AppRoutes.createApplication);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: BlocBuilder<TicketsBloc, TicketsState>(
        bloc: _ticketsBloc,
        builder: (context, state) {
          // Отображаем индикатор загрузки
          if (state is TicketsInitial || state is TicketsLoading) {
            return const Center(child: GrayLoadingIndicator());
          }

          // Отображаем ошибку
          if (state is TicketsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.error,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _loadTickets();
                    },
                    child: Text(AppStrings.repeat),
                  ),
                ],
              ),
            );
          }

          // Получаем данные заявок и статистику из API
          final tickets = state is TicketsLoaded ? state.tickets : <Ticket>[];
          final apiStats = state is TicketsLoaded ? state.stats : <Stat>[];
          final stats = _calculateStats(tickets, apiStats);

          return RefreshIndicator(
            onRefresh: () async {
              _loadTickets();
              _loadEmployees();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Все заявки",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 14),

                  SizedBox(
                    height: 165,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pie Chart
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Переход на страницу с заявками с табом "Все"
                              final queryParams = <String, String>{};
                              if (selectedDate != null) {
                                queryParams['startDate'] = DateTimeUtils.formatDateForApi(selectedDate!.start);
                                queryParams['endDate'] = DateTimeUtils.formatDateForApi(selectedDate!.end);
                              }

                              final uri = Uri(
                                path: '${AppRoutes.managerTickets}/0',
                                queryParameters: queryParams.isEmpty ? null : queryParams,
                              );

                              context.push(uri.toString());
                            },
                            child: MainCardWidget(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Все ${stats['total']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    height: 110,
                                    width: 110,
                                    child: PieChart(
                                      PieChartData(
                                        sections: [
                                          if (stats['inProgress'] > 0)
                                            PieChartSectionData(
                                              color: AppColors.lightBlue,
                                              value: stats['inProgress']
                                                  .toDouble(),
                                              title: '',
                                              radius: 20,
                                            ),
                                          if (stats['handleExecutor'] > 0)
                                            PieChartSectionData(
                                              color: AppColors.lightRed,
                                              value: stats['handleExecutor']
                                                  .toDouble(),
                                              title: '',
                                              radius: 20,
                                            ),
                                          if (stats['control'] > 0)
                                            PieChartSectionData(
                                              color: AppColors.yellow,
                                              value: stats['control']
                                                  .toDouble(),
                                              title: '',
                                              radius: 20,
                                            ),
                                          if (stats['done'] > 0)
                                            PieChartSectionData(
                                              color: AppColors.lightGreen,
                                              value: stats['done'].toDouble(),
                                              title: '',
                                              radius: 20,
                                            ),
                                        ],
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              GestureDetector(
                                onTap: () {
                                  // Переход на страницу с табом "В работе" (индекс 2)

                                  final queryParams = <String, String>{};
                                  if (selectedDate != null) {
                                    queryParams['startDate'] = DateTimeUtils.formatDateForApi(selectedDate!.start);
                                    queryParams['endDate'] = DateTimeUtils.formatDateForApi(selectedDate!.end);
                                  }

                                  final uri = Uri(
                                    path: '${AppRoutes.managerTickets}/1',
                                    queryParameters: queryParams.isEmpty ? null : queryParams,
                                  );

                                  context.push(uri.toString());

                                },
                                child: StatCard(
                                  title: "В работе",
                                  value: "${stats['inProgress']}",
                                  percent: "${stats['inProgressPercent']}%",
                                  color: Colors.blue,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {

                                  final queryParams = <String, String>{};
                                  if (selectedDate != null) {
                                    queryParams['startDate'] = DateTimeUtils.formatDateForApi(selectedDate!.start);
                                    queryParams['endDate'] = DateTimeUtils.formatDateForApi(selectedDate!.end);
                                  }

                                  final uri = Uri(
                                    path: '${AppRoutes.managerTickets}/3',
                                    queryParameters: queryParams.isEmpty ? null : queryParams,
                                  );

                                  context.push(uri.toString());

                                  },
                                child: StatCard(
                                  title: "Передана исполнителю",
                                  value: "${stats['handleExecutor']}",
                                  percent: "${stats['handleExecutor']}%",
                                  color: Color(0xffEB7B36),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Переход на страницу с табом "Согласование" (индекс 3)

                              final queryParams = <String, String>{};
                              if (selectedDate != null) {
                                queryParams['startDate'] = DateTimeUtils.formatDateForApi(selectedDate!.start);
                                queryParams['endDate'] = DateTimeUtils.formatDateForApi(selectedDate!.end);
                              }

                              final uri = Uri(
                                path: '${AppRoutes.managerTickets}/4',
                                queryParameters: queryParams.isEmpty ? null : queryParams,
                              );

                              context.push(uri.toString());

                            },
                            child: StatCard(
                              title: "Контроль",
                              value: "${stats['control']}",
                              percent: "${stats['controlPercent']}%",
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Переход на страницу с табом "Выполнено" (индекс 4)
                              final queryParams = <String, String>{};
                              if (selectedDate != null) {
                                queryParams['startDate'] = DateTimeUtils.formatDateForApi(selectedDate!.start);
                                queryParams['endDate'] = DateTimeUtils.formatDateForApi(selectedDate!.end);
                              }

                              final uri = Uri(
                                path: '${AppRoutes.managerTickets}/2',
                                queryParameters: queryParams.isEmpty ? null : queryParams,
                              );

                              context.push(uri.toString());

                            },
                            child: StatCard(
                              title: "Выполнено",
                              value: "${stats['done']}",
                              percent: "${stats['donePercent']}%",
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  BlocBuilder<EmployeesBloc, EmployeesState>(
                    bloc: _employeesBloc,
                    builder: (context, employeesState) {
                      final employees = employeesState is EmployeesLoaded
                          ? employeesState.employees
                          : <Employee>[];
                      final employeesCount = employees.length;

                      return ExpansionTile(
                        title: Text(
                          "Сотрудники ($employeesCount)",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        initiallyExpanded: true,
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        children: [
                          SelectBtn(
                            title: 'Выберите сотрудника',
                            showBorder: false,
                            icon: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.lightGrayBorder,
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 14,
                                color: AppColors.white,
                              ),
                            ),
                            onTap: _showPerformer,
                          ),
                          if (employeesState is EmployeesLoading)
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: const GrayLoadingIndicator(),
                              ),
                            )
                          else if (employeesState is EmployeesError)
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Text(
                                  'Ошибка загрузки: ${employeesState.message}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                          else if (employees.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Text(
                                  'Сотрудники не найдены',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                          else
                            ...employees.map((employee) {
                              return EmployeeCard(
                                name: employee.fullName ?? 'Не указано',
                                role: employee.position ?? 'Не указано',
                                ratio: employee.statistics ?? '0/0',
                              );
                            }).toList(),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  BlocBuilder<AddressesBloc, AddressesState>(


                    builder: (context, state) {
                      final addresses =
                      state is AddressesLoaded ? (state.addresses ?? []) : <AddressData>[];

                      final addressCount = addresses.length;

                      return ExpansionTile(
                        title: Text(
                          "Объекты ($addressCount)",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        initiallyExpanded: true,
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        // optional
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        children: [
                          SelectBtn(
                            title: 'Выберите объект',
                            showBorder: false,
                            icon: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.lightGrayBorder,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 14,
                                color: AppColors.white,
                              ),
                            ),
                            onTap: _showObject,
                          ),

                          if (state is AddressesLoading)
                            const Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (state is AddressesError)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(state.message),
                            )
                          else
                            ...addresses.map((a) => ObjectCard(
                              address: a.address ?? '',
                              stats: _mapStatsToCard(a.statistics),
                            )),
                        ],
                        // children: [
                        //   SelectBtn(
                        //     title: 'Выберите объект',
                        //     showBorder: false,
                        //     //   value: selectedAddress,
                        //     icon: Container(
                        //       padding: EdgeInsets.all(5),
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: AppColors.lightGrayBorder,
                        //       ),
                        //       child: Icon(
                        //         Icons.arrow_forward_ios_outlined,
                        //         size: 14,
                        //         color: AppColors.white,
                        //       ),
                        //     ),
                        //     onTap: _showObject,
                        //   ),
                        //   ObjectCard(
                        //     address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                        //     stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                        //   ),
                        //   ObjectCard(
                        //     address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                        //     stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                        //   ),
                        //   ObjectCard(
                        //     address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                        //     stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                        //   ),
                        //   ObjectCard(
                        //     address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                        //     stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                        //   ),
                        // ],
                      );
                    }
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Map<String, int> _mapStatsToCard(dynamic statistics) {
    // если statistics у тебя Map<String, dynamic>
    if (statistics is Map<String, dynamic>) {
      int v(String k) => (statistics[k] as num?)?.toInt() ?? 0;

      return {
        "blue": v("in_progress"),
        "red": v("control"),
        "green": v("done"),
        "orange": v("approval"),
      };
    }

    // если statistics у тебя типизированная модель AddressStatistics
    // замени поля под свою модель
    return {
      "blue": statistics?.inProgress ?? 0,
      "red": statistics?.control ?? 0,
      "green": statistics?.done ?? 0,
      "orange": statistics?.approval ?? 0,
    };
  }

  _showFilter() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: FilterApplicationsWidget(
        ticketsBloc: _ticketsBloc,
        initialDate: selectedDate,
        onFiltersApplied: (date) {
          setState(() {
            selectedDate = date;
          });
          // Перезагружаем заявки с новым периодом для обновления статистики
          _loadTickets();
        },
      ),
    );
  }

  _showPerformer() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: PerformerWidget(
        onSelectItem: (String value) {
          selectedPerformer = value;
        },
        onSelectEmployee: (employee) {
          // Закрываем bottom sheet перед переходом
          Navigator.of(context).pop();
          // Передаем executor_id при переходе
          context.push(
            '${AppRoutes.performerDetails}/${employee.fullName ?? selectedPerformer}',
            extra: {'executorId': employee.id},
          );
        },
        isSelected: false,
      ),
    );
  }

  _showObject() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child:  AddressWidget(
        selectedAddress: selectedAddress,
        onSelectItem: (address, addressData) {
          setState(() {
            selectedAddress = address;
            // _selectedAddressData = addressData;
          });
          context.push(AppRoutes.addressDetails);
        },
      ),
      // AddressWidget(
      //   onSelectItem: (String value) {
      //     setState(() {
      //     selectedAddress = value;
      //     });
      //     // context.push('${AppRoutes.addressDetails}/$selectedAddress');
      //     context.push(AppRoutes.addressDetails);
      //
      //   },
      //   isSelected: false,
      // ),
    );
  }
}

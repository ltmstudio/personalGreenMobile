import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/utils/date_time_utils.dart';
import 'package:hub_dom/data/models/tickets/ticket_response_model.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/tickets/tickets_bloc.dart';
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

import 'components/address_widget.dart';
import 'components/performer_widget.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  late final TicketsBloc _ticketsBloc;
  DateTimeRange<DateTime>? selectedDate;
  String? selectedAddress;
  String? selectedPerformer;

  @override
  void initState() {
    super.initState();
    _ticketsBloc = locator<TicketsBloc>();
    // Загружаем все заявки без фильтров для дашборда
    _loadTickets();
    clear();
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
    int done = 0;
    int overdue = 0;

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
        case 'done':
          done = stat.count ?? 0;
          break;
        case 'overdue':
        case 'expired':
        case 'delayed':
          // API может возвращать просроченные под разными названиями
          overdue = stat.count ?? 0;
          break;
      }
    }

    return {
      'total': total,
      'handleExecutor': handleExecutor,
      'inProgress': inProgress,
      'approval': approval,
      'done': done,
      'overdue': overdue,
      'handleExecutorPercent': total > 0
          ? ((handleExecutor / total) * 100).toStringAsFixed(0)
          : '0',
      'inProgressPercent': total > 0
          ? ((inProgress / total) * 100).toStringAsFixed(0)
          : '0',
      'approvalPercent': total > 0
          ? ((approval / total) * 100).toStringAsFixed(0)
          : '0',
      'donePercent': total > 0
          ? ((done / total) * 100).toStringAsFixed(0)
          : '0',
      'overduePercent': total > 0
          ? ((overdue / total) * 100).toStringAsFixed(0)
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
            return const Center(child: CircularProgressIndicator());
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
                              context.push(
                                AppRoutes.managerTickets,
                                extra: {'initialTab': 0},
                              );
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
                                          if (stats['overdue'] > 0)
                                            PieChartSectionData(
                                              color: AppColors.lightRed,
                                              value: stats['overdue']
                                                  .toDouble(),
                                              title: '',
                                              radius: 20,
                                            ),
                                          if (stats['inProgress'] > 0)
                                            PieChartSectionData(
                                              color: AppColors.lightBlue,
                                              value: stats['inProgress']
                                                  .toDouble(),
                                              title: '',
                                              radius: 20,
                                            ),
                                          if (stats['approval'] > 0)
                                            PieChartSectionData(
                                              color: AppColors.yellow,
                                              value: stats['approval']
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
                                  context.push(
                                    AppRoutes.managerTickets,
                                    extra: {'initialTab': 2},
                                  );
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
                                  context.push(
                                    '${AppRoutes.appCategory}/Просрочено',
                                  );
                                },
                                child: StatCard(
                                  title: "Просрочено",
                                  value: "${stats['overdue']}",
                                  percent: "${stats['overduePercent']}%",
                                  color: Colors.red,
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
                              context.push(
                                AppRoutes.managerTickets,
                                extra: {'initialTab': 3},
                              );
                            },
                            child: StatCard(
                              title: "Контроль",
                              value: "${stats['approval']}",
                              percent: "${stats['approvalPercent']}%",
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Переход на страницу с табом "Выполнено" (индекс 4)
                              context.push(
                                AppRoutes.managerTickets,
                                extra: {'initialTab': 4},
                              );
                            },
                            child: StatCard(
                              title: "Выполнена",
                              value: "${stats['done']}",
                              percent: "${stats['donePercent']}%",
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ExpansionTile(
                    title: Text(
                      "Сотрудники (42)",
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
                        title: 'Выберите сотрудника',
                        //value: selectedPerformer,
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
                      EmployeeCard(
                        name: "Иванов Иван Иванович",
                        role: "Сантехник",
                        ratio: "12/30",
                      ),
                      EmployeeCard(
                        name: "Иванов Иван Иванович",
                        role: "Сантехник",
                        ratio: "12/30",
                      ),
                      EmployeeCard(
                        name: "Иванов Иван Иванович",
                        role: "Сантехник",
                        ratio: "12/30",
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  ExpansionTile(
                    title: Text(
                      "Объекты (42)",
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
                        //   value: selectedAddress,
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
                        onTap: _showObject,
                      ),
                      ObjectCard(
                        address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                        stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                      ),
                      ObjectCard(
                        address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                        stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                      ),
                      ObjectCard(
                        address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                        stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                      ),
                      ObjectCard(
                        address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                        stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
          // setState(() {
          selectedPerformer = value;
          // });
          context.push('${AppRoutes.performerDetails}/$selectedPerformer');
        },
        isSelected: false,
      ),
    );
  }

  _showObject() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: AddressWidget(
        onSelectItem: (String value) {
          // setState(() {
          selectedAddress = value;
          // });
          context.push('${AppRoutes.addressDetails}/$selectedAddress');
        },
        isSelected: false,
      ),
    );
  }
}

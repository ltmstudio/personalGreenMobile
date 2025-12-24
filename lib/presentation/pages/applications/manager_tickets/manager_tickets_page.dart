import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/utils/date_time_utils.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/tickets/tickets_bloc.dart';
import 'package:hub_dom/presentation/widgets/appbar_icon.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/cards/app_item_card.dart';
import 'package:hub_dom/presentation/widgets/chip_widget.dart';
import 'package:hub_dom/presentation/widgets/gray_loading_indicator.dart';
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';

import 'components/filter_manager_tickets_widget.dart';

class ManagerTicketsPage extends StatefulWidget {
  const ManagerTicketsPage({
    super.key,
    this.initialTab = 0,
    this.initialSelectedDate,
  });

  final int initialTab;
  final DateTimeRange<DateTime>? initialSelectedDate;

  @override
  State<ManagerTicketsPage> createState() => _ManagerTicketsPageState();
}

class _ManagerTicketsPageState extends State<ManagerTicketsPage> {
  late final TicketsBloc _ticketsBloc;
  bool isSearching = false;
  final TextEditingController searchCtrl = TextEditingController();

  late int selectedCategory;

  // Стандартные статусы из API
  List<StatusModel> get standardStatuses {
    return [
      StatusModel(
        name: 'in_progress',
        title: 'В работе',
        color: '#87CFF8',
        fontColor: '#127BF6',
      ),
      StatusModel(
        name: 'done',
        title: 'Выполнена',
        color: '#93CD64',
        fontColor: '#3DAE3B',
      ),
      StatusModel(
        name: 'approval',
        title: 'Согласование',
        color: '#EB7B36',
        fontColor: '#CF5104',
      ),
      StatusModel(
        name: 'control',
        title: 'Контроль',
        color: '#F1D675',
        fontColor: '#D18800',
      ),
    ];
  }

  List<String> get statusTitles {
    return ['Все', ...standardStatuses.map((s) => s.title ?? '').toList()];
  }

  // Состояние фильтров
  DateTimeRange<DateTime>? selectedDate;
  DateTimeRange<DateTime>?
  _initialDateFromDashboard; // Период, переданный со страницы статистики
  ServiceType? selectedServiceType;
  TroubleType? selectedTroubleType;
  Type? selectedPriorityType;

  @override
  void initState() {
    super.initState();
    _ticketsBloc = locator<TicketsBloc>();

    // Устанавливаем начальный таб
    selectedCategory = widget.initialTab;

    // Сохраняем переданный период со страницы статистики
    print('[ManagerTicketsPage] initState:');
    print('  widget.initialSelectedDate=${widget.initialSelectedDate}');
    if (widget.initialSelectedDate != null) {
      selectedDate = widget.initialSelectedDate;
      _initialDateFromDashboard = widget.initialSelectedDate;
      print('  Период установлен: selectedDate=$selectedDate');
    } else {
      print('  Период не передан через конструктор');
    }

    // Загружаем tickets при инициализации
    _loadTicketsForTab(selectedCategory);
  }

  @override
  void didUpdateWidget(ManagerTicketsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('[ManagerTicketsPage] didUpdateWidget:');
    print('  oldWidget.initialTab=${oldWidget.initialTab}');
    print('  widget.initialTab=${widget.initialTab}');
    print('  oldWidget.initialSelectedDate=${oldWidget.initialSelectedDate}');
    print('  widget.initialSelectedDate=${widget.initialSelectedDate}');

    // Проверяем, изменились ли параметры виджета
    bool shouldReload = false;

    // Если изменился таб
    if (oldWidget.initialTab != widget.initialTab) {
      selectedCategory = widget.initialTab;
      shouldReload = true;
      print('  Tab changed, updating selectedCategory to ${widget.initialTab}');
    }

    // Если изменился период
    if (oldWidget.initialSelectedDate != widget.initialSelectedDate) {
      selectedDate = widget.initialSelectedDate;
      _initialDateFromDashboard = widget.initialSelectedDate;
      shouldReload = true;
      print('  Date changed, updating to ${widget.initialSelectedDate}');
    }

    // Перезагружаем данные если что-то изменилось
    if (shouldReload) {
      print('  Reloading tickets with new parameters');
      _loadTicketsForTab(selectedCategory);
    }
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _ticketsBloc.close();
    super.dispose();
  }

  /// Загружает заявки для выбранного таба с учетом всех фильтров
  void _loadTicketsForTab(int tabIndex) {
    String? startDate;
    String? endDate;

    // Используем период из _initialDateFromDashboard, если он есть, иначе из selectedDate
    final dateToUse = _initialDateFromDashboard ?? selectedDate;

    print('[ManagerTicketsPage] _loadTicketsForTab:');
    print('  tabIndex=$tabIndex');
    print('  selectedDate=$selectedDate');
    print('  _initialDateFromDashboard=$_initialDateFromDashboard');
    print('  dateToUse=$dateToUse');

    // Если есть выбранный период, используем его
    if (dateToUse != null) {
      startDate = DateTimeUtils.formatDateForApi(dateToUse.start);
      endDate = DateTimeUtils.formatDateForApi(dateToUse.end);
      print('  startDate для API: $startDate');
      print('  endDate для API: $endDate');
    } else {
      print('  Период не установлен - запрос будет без дат');
    }

    String? statusApiValue;
    if (tabIndex != 0) {
      // Фильтруем по конкретному статусу
      statusApiValue = _getStatusApiValue(tabIndex);
      print(
        '  statusApiValue=$statusApiValue, tabTitle=${statusTitles[tabIndex]}',
      );
    }

    final event = LoadTicketsEvent(
      page: 1,
      perPage: 1000,
      status: statusApiValue,
      startDate: startDate,
      endDate: endDate,
      serviceTypeId: selectedServiceType?.id,
      troubleTypeId: selectedTroubleType?.id,
      priorityTypeId: selectedPriorityType?.id,
    );

    log(event.toString(), name: 'big');

    _ticketsBloc.add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? HomePageSearchWidget(
                searchCtrl: searchCtrl,
                onSearch: () {
                  _ticketsBloc.add(
                    LoadTicketsEvent(
                      searchText: searchCtrl.text,
                      page: 1,
                      perPage: 1000,
                    ),
                  );
                },
          onClear: (){
                  searchCtrl.clear();


                  _ticketsBloc.add(LoadTicketsEvent(
                    searchText: '',
                    page: 1,
                    perPage: 1000,
                  ));
          },
              )
            : Text(AppStrings.applications),
        actions: isSearching
            ? [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchCtrl.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                    });
                  },
                  child: Text(
                    AppStrings.cancelIt,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ]
            : [
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
                  padding: const EdgeInsets.only(right: 8.0, top: 10),
                  child: AppBarIcon(
                    icon: IconAssets.filter,
                    onTap: _showFilter,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 10),
                  child: AppBarIcon(
                    icon: IconAssets.search,
                    onTap: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
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
          // Начальное состояние и загрузка показывают индикатор
          if (state is TicketsInitial || state is TicketsLoading) {
            return const Center(child: GrayLoadingIndicator());
          }

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
                      _ticketsBloc.add(const RefreshTicketsEvent());
                    },
                    child: Text(AppStrings.repeat),
                  ),
                ],
              ),
            );
          }

          // Для состояний TicketsEmpty и TicketsLoaded показываем табы
          if (state is TicketsEmpty || state is TicketsLoaded) {
            // Синхронизируем локальное состояние с состоянием BLoC
            if (state is TicketsLoaded) {
              // Обновляем период из BLoC, если он изменился
              if (state.currentStartDate != null &&
                  state.currentEndDate != null) {
                try {
                  final startDate = DateTime.parse(state.currentStartDate!);
                  final endDate = DateTime.parse(state.currentEndDate!);
                  final blocDate = DateTimeRange(
                    start: startDate,
                    end: endDate,
                  );
                  if (selectedDate != blocDate) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          selectedDate = blocDate;
                          _initialDateFromDashboard = blocDate;
                        });
                      }
                    });
                  }
                } catch (e) {
                  // Игнорируем ошибки парсинга
                }
              }
            }

            final ticketsCount = state is TicketsLoaded
                ? state.tickets.length
                : 0;
            final emptyState = state is TicketsEmpty ? state : null;
            final isEmptyState = emptyState != null;

            return RefreshIndicator(
              onRefresh: () async {
                _ticketsBloc.add(const RefreshTicketsEvent());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Фильтры по статусам - всегда видны
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: statusTitles.length,
                        itemBuilder: (context, index) {
                          return ChipWidget(
                            title: statusTitles[index],
                            isSelected: index == selectedCategory,
                            onTap: () {
                              setState(() {
                                selectedCategory = index;
                                // Сбрасываем период только если он был изменен на странице заявок
                                // (т.е. отличается от переданного со страницы статистики)
                                if (_initialDateFromDashboard != null &&
                                    selectedDate != _initialDateFromDashboard) {
                                  // Период был изменен на странице заявок - сбрасываем
                                  selectedDate = null;
                                }
                              });
                              _loadTicketsForTab(index);
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 5),
                      ),
                    ),

                    // Заголовок с количеством
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.allApps,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          ChipWidget(title: '$ticketsCount'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Если пусто - показываем сообщение
                    if (isEmptyState)
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                emptyState.hasFilters
                                    ? AppStrings.emptySearch
                                    : AppStrings.empty,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                emptyState.hasFilters
                                    ? AppStrings.emptySearchBody
                                    : 'Заявки будут отображаться здесь',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Иначе показываем список заявок с группировкой по датам
                    if (!isEmptyState)
                      ..._buildTicketsList(state as TicketsLoaded),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Строит список заявок с группировкой по датам
  List<Widget> _buildTicketsList(TicketsLoaded state) {
    if (state.tickets.isEmpty) {
      return [];
    }

    // Группируем заявки по датам
    final Map<String, List<dynamic>> groupedTickets = {};

    for (final ticket in state.tickets) {
      if (ticket.createdAt != null) {
        final dateKey = DateTimeUtils.getRelativeDate(ticket.createdAt!);
        groupedTickets.putIfAbsent(dateKey, () => []).add(ticket);
      } else {
        // Заявки без даты в отдельную группу
        groupedTickets.putIfAbsent('Без даты', () => []).add(ticket);
      }
    }

    final List<Widget> widgets = [];

    groupedTickets.forEach((dateKey, tickets) {
      // Заголовок с датой
      widgets.add(
        Align(
          alignment: Alignment.center,
          child: ChipWidget(title: dateKey),
        ),
      );

      // Заявки за эту дату
      for (final ticket in tickets) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppItemCard(isManager: true, ticket: ticket),
          ),
        );
      }
    });

    return widgets;
  }

  /// Получает API значение статуса по индексу
  /// ВАЖНО: Маппинг индексов табов на статусы API
  /// statusTitles: ['Все', 'В работе', 'Выполнено', 'Согласование', 'Контроль']
  /// Индексы: 0=Все, 1=В работе, 2=Выполнено, 3=Согласование, 4=Контроль
  String? _getStatusApiValue(int index) {
    if (index == 0) return null; // Все
    // Явный маппинг индексов табов на статусы API
    switch (index) {
      case 1:
        return 'in_progress'; // В работе
      case 2:
        return 'done'; // Выполнено
      case 3:
        return 'approval'; // Согласование
      case 4:
        return 'control'; // Контроль
      default:
        if (index > 0 && index <= standardStatuses.length) {
          return standardStatuses[index - 1].name;
        }
        return null;
    }
  }

  _showFilter() {
    // Получаем период из состояния BLoC, если он есть
    DateTimeRange<DateTime>? dateFromBloc;
    final currentState = _ticketsBloc.state;
    if (currentState is TicketsLoaded) {
      if (currentState.currentStartDate != null &&
          currentState.currentEndDate != null) {
        try {
          final startDate = DateTime.parse(currentState.currentStartDate!);
          final endDate = DateTime.parse(currentState.currentEndDate!);
          dateFromBloc = DateTimeRange(start: startDate, end: endDate);
        } catch (e) {
          // Игнорируем ошибки парсинга
        }
      }
    }

    // Используем период из BLoC, если он есть, иначе из переданного через конструктор
    final dateToPass = dateFromBloc ?? _initialDateFromDashboard;

    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: FilterManagerTicketsWidget(
        ticketsBloc: _ticketsBloc,
        initialDate: dateToPass,
        initialServiceType: selectedServiceType,
        initialTroubleType: selectedTroubleType,
        initialPriorityType: selectedPriorityType,
        onFiltersApplied: (date, serviceType, troubleType, priorityType) {
          // Обновляем фильтры через BLoC
          String? startDate;
          String? endDate;
          if (date != null) {
            startDate = DateTimeUtils.formatDateForApi(date.start);
            endDate = DateTimeUtils.formatDateForApi(date.end);
          }

          // Получаем статус для текущего таба
          String? statusApiValue;
          if (selectedCategory != 0) {
            statusApiValue = _getStatusApiValue(selectedCategory);
          }

          // Обновляем фильтры через BLoC
          _ticketsBloc.add(
            UpdateTicketsFiltersEvent(
              startDate: startDate,
              endDate: endDate,
              status: statusApiValue,
              serviceTypeId: serviceType?.id,
              troubleTypeId: troubleType?.id,
              priorityTypeId: priorityType?.id,
              page: 1,
              perPage: 1000,
            ),
          );

          // Обновляем локальное состояние для отображения в UI
          setState(() {
            selectedDate = date;
            selectedServiceType = serviceType;
            selectedTroubleType = troubleType;
            selectedPriorityType = priorityType;
            if (date != null) {
              _initialDateFromDashboard = date;
            } else {
              _initialDateFromDashboard = null;
            }
          });
        },
      ),
    );
  }
}

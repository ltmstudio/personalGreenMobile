import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/utils/date_time_utils.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';
import 'package:hub_dom/data/models/tickets/ticket_response_model.dart';
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

import 'components/filter_time_widget.dart';

class AppCategoryPage extends StatefulWidget {
  const AppCategoryPage({super.key, required this.title});

  final String title;

  @override
  State<AppCategoryPage> createState() => _AppCategoryPageState();
}

class _AppCategoryPageState extends State<AppCategoryPage> {
  late final TicketsBloc _ticketsBloc;
  bool isSearching = false;
  final TextEditingController searchCtrl = TextEditingController();

  int selectedCategory = 0;

  // Стандартные статусы из API
  List<StatusModel> get standardStatuses {
    return [
      StatusModel(name: 'in_progress', title: 'В работе', color: '#87CFF8'),
      StatusModel(name: 'done', title: 'Выполнено', color: '#93CD64'),
      StatusModel(name: 'approval', title: 'Согласование', color: '#EB7B36'),
      StatusModel(name: 'control', title: 'Контроль', color: '#F1D675'),
    ];
  }

  List<String> get statusTitles {
    return ['Все', ...standardStatuses.map((s) => s.title ?? '').toList()];
  }

  // Состояние фильтров
  DateTimeRange? selectedDate;
  ServiceType? selectedServiceType;
  TroubleType? selectedTroubleType;
  Type? selectedPriorityType;
  int? selectedExecutorId;

  @override
  void initState() {
    super.initState();
    _ticketsBloc = locator<TicketsBloc>();
    _loadTicketsForCategory();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _ticketsBloc.close();
    super.dispose();
  }

  /// Загружает заявки в зависимости от категории (title) с учетом фильтров
  void _loadTicketsForCategory() {
    final String? status = _getStatusFromTitle(widget.title);

    String? startDate;
    String? endDate;

    // Если есть выбранный период, используем его
    if (selectedDate != null) {
      startDate = DateTimeUtils.formatDateForApi(selectedDate!.start);
      endDate = DateTimeUtils.formatDateForApi(selectedDate!.end);
    }

    if (widget.title == 'Все') {
      // Загружаем все заявки
      _ticketsBloc.add(
        LoadTicketsEvent(
          page: 1,
          perPage: 1000,
          startDate: startDate,
          endDate: endDate,
          serviceTypeId: selectedServiceType?.id,
          troubleTypeId: selectedTroubleType?.id,
          priorityTypeId: selectedPriorityType?.id,
          executorId: selectedExecutorId,
        ),
      );
    } else if (status != null) {
      // Загружаем заявки по конкретному статусу
      _ticketsBloc.add(
        LoadTicketsEvent(
          page: 1,
          perPage: 1000,
          status: status,
          startDate: startDate,
          endDate: endDate,
          serviceTypeId: selectedServiceType?.id,
          troubleTypeId: selectedTroubleType?.id,
          priorityTypeId: selectedPriorityType?.id,
          executorId: selectedExecutorId,
        ),
      );
    } else {
      // По умолчанию загружаем все заявки
      _ticketsBloc.add(
        LoadTicketsEvent(
          page: 1,
          perPage: 1000,
          startDate: startDate,
          endDate: endDate,
          serviceTypeId: selectedServiceType?.id,
          troubleTypeId: selectedTroubleType?.id,
          priorityTypeId: selectedPriorityType?.id,
          executorId: selectedExecutorId,
        ),
      );
    }
  }

  /// Получает API-значение статуса по названию категории
  String? _getStatusFromTitle(String title) {
    for (final status in standardStatuses) {
      if (status.title == title) {
        return status.name;
      }
    }
    return null;
  }

  /// Фильтрует заявки по выбранной категории
  List<Ticket> _filterTickets(List<Ticket> tickets) {
    // Вся фильтрация происходит на уровне API
    // Просто возвращаем то, что пришло
    return tickets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? HomePageSearchWidget(searchCtrl: searchCtrl, onSearch: () {})
            : Text(widget.title),
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
          // Отображаем индикатор загрузки
          if (state is TicketsInitial || state is TicketsLoading) {
            return Center(
              child: const GrayLoadingIndicator(),
            );
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
                      _loadTicketsForCategory();
                    },
                    child: Text(AppStrings.repeat),
                  ),
                ],
              ),
            );
          }

          // Получаем и фильтруем заявки
          final allTickets = state is TicketsLoaded
              ? state.tickets
              : <Ticket>[];
          final filteredTickets = _filterTickets(allTickets);
          final ticketsCount = filteredTickets.length;

          // Проверяем, есть ли заявки
          final isEmpty = filteredTickets.isEmpty;

          return RefreshIndicator(
            onRefresh: () async {
              _loadTicketsForCategory();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title.contains('Все'))
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: statusTitles.length,
                        itemBuilder: (context, index) {
                          return ChipWidget(
                            title: statusTitles[index],
                            isSelected: index == selectedCategory,
                            onTap: () {
                              setState(() {
                                selectedCategory = index;
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 5),
                      ),
                    ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
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

                  // Если нет заявок - показываем сообщение
                  if (isEmpty)
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
                              AppStrings.empty,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Заявки будут отображаться здесь',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Иначе показываем список заявок с группировкой по датам
                  if (!isEmpty) ..._buildTicketsList(filteredTickets),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Строит список заявок с группировкой по датам
  List<Widget> _buildTicketsList(List<Ticket> tickets) {
    if (tickets.isEmpty) {
      return [];
    }

    // Группируем заявки по датам
    final Map<String, List<Ticket>> groupedTickets = {};

    for (final ticket in tickets) {
      if (ticket.createdAt != null) {
        final dateKey = DateTimeUtils.getRelativeDate(ticket.createdAt!);
        groupedTickets.putIfAbsent(dateKey, () => []).add(ticket);
      } else {
        // Заявки без даты в отдельную группу
        groupedTickets.putIfAbsent('Без даты', () => []).add(ticket);
      }
    }

    final List<Widget> widgets = [];

    groupedTickets.forEach((dateKey, ticketsForDate) {
      // Заголовок с датой
      widgets.add(
        Align(
          alignment: Alignment.center,
          child: ChipWidget(title: dateKey),
        ),
      );

      // Заявки за эту дату
      for (final ticket in ticketsForDate) {
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

  _showFilter() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: FilterCategoryWidget(
        initialDate: selectedDate,
        initialServiceType: selectedServiceType,
        initialTroubleType: selectedTroubleType,
        initialPriorityType: selectedPriorityType,
        initialExecutorId: selectedExecutorId,
        onFiltersApplied:
            (date, serviceType, troubleType, priorityType, executorId) {
              setState(() {
                selectedDate = date;
                selectedServiceType = serviceType;
                selectedTroubleType = troubleType;
                selectedPriorityType = priorityType;
                selectedExecutorId = executorId;
              });
              // Перезагружаем заявки с новыми фильтрами
              _loadTicketsForCategory();
              // Закрываем bottom sheet после применения фильтров
              context.pop();
            },
      ),
    );
  }
}

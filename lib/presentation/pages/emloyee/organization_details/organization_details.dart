import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/utils/date_time_utils.dart';
import 'package:hub_dom/data/models/auth/crm_system_model.dart';
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
import 'components/filter_organization_widget.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';

class OrganizationDetailsPage extends StatefulWidget {
  const OrganizationDetailsPage({super.key, required this.model});

  final CrmSystemModel model;

  @override
  State<OrganizationDetailsPage> createState() =>
      _OrganizationDetailsPageState();
}

class _OrganizationDetailsPageState extends State<OrganizationDetailsPage> {
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
  DateTimeRange<DateTime>? selectedDate;
  ServiceType? selectedServiceType;
  TroubleType? selectedTroubleType;
  Type? selectedPriorityType;

  @override
  void initState() {
    super.initState();
    _ticketsBloc = locator<TicketsBloc>();

    // Загружаем все tickets при инициализации (без фильтров)
    _ticketsBloc.add(const LoadTicketsEvent(page: 1, perPage: 10));
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _ticketsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? HomePageSearchWidget(searchCtrl: searchCtrl, onSearch: () {})
            : Text(widget.model.crm.name),
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
            context.push(AppRoutes.createEmployeeApp);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: BlocBuilder<TicketsBloc, TicketsState>(
        bloc: _ticketsBloc,
        builder: (context, state) {
          // Начальное состояние и загрузка показывают индикатор
          if (state is TicketsInitial || state is TicketsLoading) {
            return Center(
              child: const GrayLoadingIndicator(),
            );
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
                              });
                              _filterByStatus(index);
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
            child: AppItemCard(isManager: false, ticket: ticket),
          ),
        );
      }
    });

    return widgets;
  }

  /// Фильтрация по статусу
  void _filterByStatus(int index) {
    if (index == 0) {
      // "Все" - загружаем без фильтров (все заявки: и экстренные, и обычные, все статусы)
      _ticketsBloc.add(
        const LoadTicketsEvent(
          page: 1,
          perPage: 10,
          // Не передаем status и isEmergency чтобы получить ВСЕ заявки
        ),
      );
    } else {
      // Фильтруем по конкретному статусу (но все еще показываем и экстренные, и обычные)
      final statusApiValue = _getStatusApiValue(index);
      _ticketsBloc.add(
        LoadTicketsEvent(
          page: 1,
          perPage: 10,
          status: statusApiValue,
          // Не передаем isEmergency чтобы показать и экстренные, и обычные заявки этого статуса
        ),
      );
    }
  }

  /// Получает API значение статуса по индексу
  String? _getStatusApiValue(int index) {
    if (index == 0) return null; // Все
    if (index > 0 && index <= standardStatuses.length) {
      return standardStatuses[index - 1].name;
    }
    return null;
  }

  _showFilter() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: FilterOrganizationWidget(
        ticketsBloc: _ticketsBloc,
        initialDate: selectedDate,
        initialServiceType: selectedServiceType,
        initialTroubleType: selectedTroubleType,
        initialPriorityType: selectedPriorityType,
        onFiltersApplied: (date, serviceType, troubleType, priorityType) {
          setState(() {
            selectedDate = date;
            selectedServiceType = serviceType;
            selectedTroubleType = troubleType;
            selectedPriorityType = priorityType;
          });
        },
      ),
    );
  }
}

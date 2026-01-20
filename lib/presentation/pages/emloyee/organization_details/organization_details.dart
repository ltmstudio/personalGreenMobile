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
import '../../../../core/local/token_store.dart';
import '../../../bloc/crm_system/crm_system_cubit.dart';
import '../../../bloc/selected_crm/selected_crm_cubit.dart';
import 'components/filter_organization_widget.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';

class OrganizationDetailsPage extends StatefulWidget {
  const OrganizationDetailsPage({super.key, required this.model});

  final CrmSystemModel? model;

  @override
  State<OrganizationDetailsPage> createState() =>
      _OrganizationDetailsPageState();
}

class _OrganizationDetailsPageState extends State<OrganizationDetailsPage> {
  late final TicketsBloc _ticketsBloc;
  CrmSystemModel? _model;
  bool _isResolvingModel = false;
  bool isSearching = false;
  final TextEditingController searchCtrl = TextEditingController();

  int selectedCategory = 0;

  // Стандартные статусы из API
  List<StatusModel> get standardStatuses {
    return [
      StatusModel(name: 'in_progress', title: 'В работе', color: '#87CFF8', fontColor: '#127BF6'),
      StatusModel(name: 'done', title: 'Выполнена', color: '#93CD64', fontColor: '#3DAE3B'),
      StatusModel(name: 'approval', title: 'Согласование', color: '#EB7B36', fontColor: '#CF5104'),
      StatusModel(name: 'control', title: 'Контроль', color: '#F1D675', fontColor: '#D18800'),
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
    _model = widget.model;
    if (_model == null) {
      _resolveModel();
    } else {
      _ticketsBloc.add(const LoadTicketsEvent(page: 1, perPage: 10));
    }
  }

  Future<void> _resolveModel() async {
    setState(() => _isResolvingModel = true);

    final selectedCrmId = await locator<Store>().getSelectedCrmId();
    if (selectedCrmId == null) {
      if (mounted) setState(() => _isResolvingModel = false);
      return;
    }

    final crmCubit = locator<CrmSystemCubit>();
    await crmCubit.getCrmSystems();

    final st = crmCubit.state;
    if (st is CrmSystemLoaded) {
      final found = st.data.where((e) => e.crm.id == selectedCrmId).toList();
      if (found.isNotEmpty) {
        _model = found.first;

        // ✅ set current crm context (host/token) WITHOUT index
        await locator<SelectedCrmCubit>().setCrmSystemByModel(_model!);

        _ticketsBloc.add(const LoadTicketsEvent(page: 1, perPage: 10));
      }
    }

    if (mounted) setState(() => _isResolvingModel = false);
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _ticketsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (_isResolvingModel) {
      return const Scaffold(
        body: Center(child: GrayLoadingIndicator()),
      );
    }

    if (_model == null) {
      return Scaffold(
        appBar: AppBar(title: Text(AppStrings.organizations)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppStrings.error),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _resolveModel,
                child: Text(AppStrings.repeat),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: isSearching
            ? HomePageSearchWidget(searchCtrl: searchCtrl, onSearch: () {})
            : Text(_model?.crm.name ?? AppStrings.organizations),
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

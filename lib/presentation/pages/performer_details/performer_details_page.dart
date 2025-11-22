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
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';
import 'package:hub_dom/data/models/tickets/ticket_response_model.dart';

import 'components/filter_performer_widget.dart';

class PerformerDetailsPage extends StatefulWidget {
  const PerformerDetailsPage({super.key, required this.title, this.executorId});

  final String title;
  final int? executorId;

  @override
  State<PerformerDetailsPage> createState() => _PerformerDetailsPageState();
}

class _PerformerDetailsPageState extends State<PerformerDetailsPage> {
  late final TicketsBloc _ticketsBloc;
  bool isSearching = false;
  final TextEditingController searchCtrl = TextEditingController();

  final statuses = AppStrings.statuses;
  int selectedCategory = 0;
  int? executorId; // Сохраняем executor_id для фильтрации

  @override
  void initState() {
    super.initState();
    _ticketsBloc = locator<TicketsBloc>();
    // Сохраняем executor_id, переданный при переходе
    executorId = widget.executorId;
    // Загружаем все заявки при инициализации
    _loadTicketsForTab(selectedCategory);
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _ticketsBloc.close();
    super.dispose();
  }

  /// Загружает заявки для выбранного таба
  void _loadTicketsForTab(int tabIndex) {
    String? statusApiValue;
    if (tabIndex != 0) {
      // Фильтруем по конкретному статусу
      statusApiValue = _getStatusApiValue(tabIndex);
    }

    // Используем widget.executorId напрямую, чтобы гарантировать, что он не null
    final currentExecutorId = executorId ?? widget.executorId;

    // Загружаем заявки с фильтром по статусу и executor_id
    _ticketsBloc.add(
      LoadTicketsEvent(
        page: 1,
        perPage: 1000,
        status: statusApiValue,
        executorId:
            currentExecutorId, // Всегда используем executor_id, если он передан
      ),
    );
  }

  /// Получает API значение статуса по индексу
  String? _getStatusApiValue(int index) {
    switch (index) {
      case 1:
        return 'in_progress'; // В работе
      case 2:
        // API не поддерживает фильтрацию по просроченным заявкам через статус
        // Возвращаем null, чтобы загрузить все заявки и фильтровать на клиенте
        return null; // Просрочена - фильтруем на клиенте
      case 3:
        return 'control'; // Контроль
      default:
        return null;
    }
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
              child: CircularProgressIndicator(color: AppColors.gray),
            );
          }

          // Отображаем ошибку
          if (state is TicketsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ошибка: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _loadTicketsForTab(selectedCategory),
                    child: Text(AppStrings.repeat),
                  ),
                ],
              ),
            );
          }

          // Получаем заявки
          final allTickets = state is TicketsLoaded
              ? state.tickets
              : <Ticket>[];

          // Фильтруем заявки по статусу на клиенте (для просроченных)
          List<Ticket> tickets = allTickets;
          if (selectedCategory == 2) {
            // Фильтруем просроченные заявки на клиенте
            final now = DateTime.now();
            tickets = allTickets.where((ticket) {
              if (ticket.deadlinedAt == null) return false;
              return ticket.deadlinedAt!.isBefore(now) &&
                  ticket.status?.name != 'done'; // Исключаем выполненные
            }).toList();
          }

          final ticketsCount = tickets.length;

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

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: statuses.length,
                    itemBuilder: (context, index) {
                      return ChipWidget(
                        title: statuses[index],
                        isSelected: index == selectedCategory,
                        onTap: () {
                          setState(() {
                            selectedCategory = index;
                          });
                          _loadTicketsForTab(index);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(width: 5),
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

                // Отображаем заявки или сообщение о пустоте
                if (widgets.isEmpty)
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
                        ],
                      ),
                    ),
                  )
                else
                  ...widgets,
              ],
            ),
          );
        },
      ),
    );
  }

  _showFilter() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: FilterPerformerWidget(),
    );
  }
}

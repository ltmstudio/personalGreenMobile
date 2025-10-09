import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/data/models/tickets/ticket_response_model.dart';
import 'package:hub_dom/data/repositories/tickets/tickets_repository.dart';

part 'tickets_event.dart';
part 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final TicketsRepository _repository;

  TicketsBloc(this._repository) : super(const TicketsInitial()) {
    on<LoadTicketsEvent>(_onLoadTickets);
    on<UpdateTicketsFiltersEvent>(_onUpdateFilters);
    on<ResetTicketsFiltersEvent>(_onResetFilters);
    on<RefreshTicketsEvent>(_onRefreshTickets);
  }

  /// Обработчик загрузки tickets
  Future<void> _onLoadTickets(
    LoadTicketsEvent event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsLoading());

    // Логируем параметры запроса
    log('=== TICKETS REQUEST ===', name: 'TicketsBloc');
    log('startDate: ${event.startDate}', name: 'TicketsBloc');
    log('endDate: ${event.endDate}', name: 'TicketsBloc');
    log('status: ${event.status}', name: 'TicketsBloc');
    log('isEmergency: ${event.isEmergency}', name: 'TicketsBloc');
    log('taxTypeId: ${event.taxTypeId}', name: 'TicketsBloc');
    log('serviceTypeId: ${event.serviceTypeId}', name: 'TicketsBloc');
    log('troubleTypeId: ${event.troubleTypeId}', name: 'TicketsBloc');
    log('priorityTypeId: ${event.priorityTypeId}', name: 'TicketsBloc');
    log(
      'sourceChannelTypeId: ${event.sourceChannelTypeId}',
      name: 'TicketsBloc',
    );
    log('page: ${event.page}', name: 'TicketsBloc');
    log('perPage: ${event.perPage}', name: 'TicketsBloc');

    final result = await _repository.getTickets(
      startDate: event.startDate,
      endDate: event.endDate,
      status: event.status,
      isEmergency: event.isEmergency,
      taxTypeId: event.taxTypeId,
      serviceTypeId: event.serviceTypeId,
      troubleTypeId: event.troubleTypeId,
      priorityTypeId: event.priorityTypeId,
      sourceChannelTypeId: event.sourceChannelTypeId,
      page: event.page,
      perPage: event.perPage,
    );

    result.fold(
      (failure) {
        log('=== TICKETS ERROR ===', name: 'TicketsBloc');
        log('Error: ${failure.message}', name: 'TicketsBloc');
        emit(TicketsError(failure.message));
      },
      (data) {
        log('=== TICKETS RESPONSE ===', name: 'TicketsBloc');
        log('Response data: $data', name: 'TicketsBloc');

        final tickets = data.tickets ?? [];
        final stats = data.stats ?? [];

        log('Tickets count: ${tickets.length}', name: 'TicketsBloc');
        log('Stats count: ${stats.length}', name: 'TicketsBloc');

        // Логируем каждый ticket
        for (int i = 0; i < tickets.length; i++) {
          final ticket = tickets[i];
          log('Ticket $i:', name: 'TicketsBloc');
          log('  - ID: ${ticket.id}', name: 'TicketsBloc');
          log(
            '  - Status: ${ticket.status?.title ?? ticket.status?.name}',
            name: 'TicketsBloc',
          );
          log('  - Status Color: ${ticket.status?.color}', name: 'TicketsBloc');
          log(
            '  - Service Type: ${ticket.serviceType?.title}',
            name: 'TicketsBloc',
          );
          log('  - Address: ${ticket.address}', name: 'TicketsBloc');
          log('  - Created At: ${ticket.createdAt}', name: 'TicketsBloc');
          log(
            '  - Executor: ${ticket.executor?.fullName}',
            name: 'TicketsBloc',
          );
        }

        // Логируем статистику
        for (int i = 0; i < stats.length; i++) {
          final stat = stats[i];
          log('Stat $i: ${stat.name} = ${stat.count}', name: 'TicketsBloc');
        }

        if (tickets.isEmpty) {
          log('=== TICKETS EMPTY ===', name: 'TicketsBloc');
          emit(
            TicketsEmpty(
              hasFilters:
                  event.startDate != null ||
                  event.endDate != null ||
                  event.status != null ||
                  event.isEmergency != null ||
                  event.taxTypeId != null ||
                  event.serviceTypeId != null ||
                  event.troubleTypeId != null ||
                  event.priorityTypeId != null ||
                  event.sourceChannelTypeId != null,
            ),
          );
        } else {
          log('=== TICKETS LOADED ===', name: 'TicketsBloc');
          emit(
            TicketsLoaded(
              tickets: tickets,
              stats: stats,
              currentStartDate: event.startDate,
              currentEndDate: event.endDate,
              currentStatus: event.status,
              currentIsEmergency: event.isEmergency,
              currentTaxTypeId: event.taxTypeId,
              currentServiceTypeId: event.serviceTypeId,
              currentTroubleTypeId: event.troubleTypeId,
              currentPriorityTypeId: event.priorityTypeId,
              currentSourceChannelTypeId: event.sourceChannelTypeId,
              currentPage: event.page,
              currentPerPage: event.perPage,
            ),
          );
        }
      },
    );
  }

  /// Обработчик обновления фильтров
  Future<void> _onUpdateFilters(
    UpdateTicketsFiltersEvent event,
    Emitter<TicketsState> emit,
  ) async {
    // Сохраняем текущие фильтры если состояние TicketsLoaded
    String? startDate = event.startDate;
    String? endDate = event.endDate;
    String? status = event.status;
    String? isEmergency = event.isEmergency;
    int? taxTypeId = event.taxTypeId;
    int? serviceTypeId = event.serviceTypeId;
    int? troubleTypeId = event.troubleTypeId;
    int? priorityTypeId = event.priorityTypeId;
    int? sourceChannelTypeId = event.sourceChannelTypeId;
    int? page = event.page;
    int? perPage = event.perPage;

    if (state is TicketsLoaded) {
      final currentState = state as TicketsLoaded;
      startDate ??= currentState.currentStartDate;
      endDate ??= currentState.currentEndDate;
      status ??= currentState.currentStatus;
      isEmergency ??= currentState.currentIsEmergency;
      taxTypeId ??= currentState.currentTaxTypeId;
      serviceTypeId ??= currentState.currentServiceTypeId;
      troubleTypeId ??= currentState.currentTroubleTypeId;
      priorityTypeId ??= currentState.currentPriorityTypeId;
      sourceChannelTypeId ??= currentState.currentSourceChannelTypeId;
      page ??= currentState.currentPage;
      perPage ??= currentState.currentPerPage;
    }

    // Загружаем tickets с новыми фильтрами
    add(
      LoadTicketsEvent(
        startDate: startDate,
        endDate: endDate,
        status: status,
        isEmergency: isEmergency,
        taxTypeId: taxTypeId,
        serviceTypeId: serviceTypeId,
        troubleTypeId: troubleTypeId,
        priorityTypeId: priorityTypeId,
        sourceChannelTypeId: sourceChannelTypeId,
        page: page,
        perPage: perPage,
      ),
    );
  }

  /// Обработчик сброса фильтров
  Future<void> _onResetFilters(
    ResetTicketsFiltersEvent event,
    Emitter<TicketsState> emit,
  ) async {
    // Загружаем tickets без фильтров
    add(const LoadTicketsEvent());
  }

  /// Обработчик обновления списка (pull-to-refresh)
  Future<void> _onRefreshTickets(
    RefreshTicketsEvent event,
    Emitter<TicketsState> emit,
  ) async {
    // Если есть текущее состояние с фильтрами, используем их
    if (state is TicketsLoaded) {
      final currentState = state as TicketsLoaded;
      add(
        LoadTicketsEvent(
          startDate: currentState.currentStartDate,
          endDate: currentState.currentEndDate,
          status: currentState.currentStatus,
          isEmergency: currentState.currentIsEmergency,
          taxTypeId: currentState.currentTaxTypeId,
          serviceTypeId: currentState.currentServiceTypeId,
          troubleTypeId: currentState.currentTroubleTypeId,
          priorityTypeId: currentState.currentPriorityTypeId,
          sourceChannelTypeId: currentState.currentSourceChannelTypeId,
          page: currentState.currentPage,
          perPage: currentState.currentPerPage,
        ),
      );
    } else {
      // Иначе загружаем без фильтров
      add(const LoadTicketsEvent());
    }
  }

  /// Вспомогательный метод для получения текущих фильтров
  Map<String, dynamic> getCurrentFilters() {
    if (state is TicketsLoaded) {
      final currentState = state as TicketsLoaded;
      return {
        'startDate': currentState.currentStartDate,
        'endDate': currentState.currentEndDate,
        'status': currentState.currentStatus,
        'isEmergency': currentState.currentIsEmergency,
        'taxTypeId': currentState.currentTaxTypeId,
        'serviceTypeId': currentState.currentServiceTypeId,
        'troubleTypeId': currentState.currentTroubleTypeId,
        'priorityTypeId': currentState.currentPriorityTypeId,
        'sourceChannelTypeId': currentState.currentSourceChannelTypeId,
        'page': currentState.currentPage,
        'perPage': currentState.currentPerPage,
      };
    }
    return {};
  }

  /// Вспомогательный метод для проверки наличия активных фильтров
  bool hasActiveFilters() {
    if (state is TicketsLoaded) {
      return (state as TicketsLoaded).hasActiveFilters;
    }
    return false;
  }
}

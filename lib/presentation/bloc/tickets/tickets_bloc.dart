import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/usecase/tickets/create_ticket_params.dart';
import 'package:hub_dom/core/usecase/tickets/create_ticket_usecase.dart';
import 'package:hub_dom/data/models/tickets/create_ticket_response_model.dart';
import 'package:hub_dom/data/models/tickets/ticket_response_model.dart';
import 'package:hub_dom/data/repositories/tickets/tickets_repository.dart';

part 'tickets_event.dart';
part 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final TicketsRepository _repository;
  final CreateTicketUseCase _createTicketUseCase;

  TicketsBloc(this._repository, this._createTicketUseCase)
    : super(const TicketsInitial()) {
    on<LoadTicketsEvent>(_onLoadTickets);
    on<UpdateTicketsFiltersEvent>(_onUpdateFilters);
    on<ResetTicketsFiltersEvent>(_onResetFilters);
    on<RefreshTicketsEvent>(_onRefreshTickets);
    on<CreateTicketEvent>(_onCreateTicket);
  }

  /// Обработчик загрузки tickets
  Future<void> _onLoadTickets(
    LoadTicketsEvent event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsLoading());

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
      executorId: event.executorId,
      page: event.page,
      perPage: event.perPage,
    );

    result.fold(
      (failure) {
        log('TicketsBloc Error: ${failure.message}', name: 'TicketsBloc');
        emit(TicketsError(failure.message));
      },
      (data) {
        final tickets = data.tickets ?? [];
        final stats = data.stats ?? [];

        if (tickets.isEmpty) {
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
                  event.sourceChannelTypeId != null ||
                  event.executorId != null,
            ),
          );
        } else {
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
              currentExecutorId: event.executorId,
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
    int? executorId = event.executorId;
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
      executorId ??= currentState.currentExecutorId;
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
        executorId: executorId,
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
          executorId: currentState.currentExecutorId,
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
        'executorId': currentState.currentExecutorId,
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

  /// Обработчик создания тикета
  Future<void> _onCreateTicket(
    CreateTicketEvent event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsCreating());

    final result = await _createTicketUseCase.execute(event.params);

    result.fold(
      (failure) {
        log('CreateTicket Error: ${failure.message}', name: 'TicketsBloc');
        emit(TicketCreationError(failure.message));
      },
      (data) {
        emit(TicketCreated(data));
      },
    );
  }
}

import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/network/network.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/data/repositories/tickets/tickets_repository.dart';

part 'application_details_event.dart';
part 'application_details_state.dart';

class ApplicationDetailsBloc
    extends Bloc<ApplicationDetailsEvent, ApplicationDetailsState> {
  final TicketsRepository _repository;
  final NetworkInfo _networkInfo;
  ApplicationDetailsLoaded? _lastLoadedState;

  ApplicationDetailsBloc(this._repository, this._networkInfo)
    : super(const ApplicationDetailsInitial()) {
    on<LoadTicketDetailsEvent>(_onLoadTicketDetails);
    on<AcceptTicketEvent>(_onAcceptTicket);
    on<RejectTicketEvent>(_onRejectTicket);
    on<AssignExecutorEvent>(_onAssignExecutor);
  }

  /// Обработчик загрузки деталей тикета
  Future<void> _onLoadTicketDetails(
    LoadTicketDetailsEvent event,
    Emitter<ApplicationDetailsState> emit,
  ) async {
    emit(const ApplicationDetailsLoading());

    log('=== LOAD TICKET DETAILS ===', name: 'ApplicationDetailsBloc');
    log('Ticket ID: ${event.ticketId}', name: 'ApplicationDetailsBloc');

    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      emit(const ApplicationDetailsError('Нет подключения к интернету'));
      return;
    }

    final result = await _repository.getTicket(event.ticketId);

    result.fold(
      (failure) {
        log('=== TICKET DETAILS ERROR ===', name: 'ApplicationDetailsBloc');
        log('Error: ${failure.message}', name: 'ApplicationDetailsBloc');
        emit(ApplicationDetailsError(failure.message));
      },
      (data) {
        log('=== TICKET DETAILS LOADED ===', name: 'ApplicationDetailsBloc');
        log('Ticket data: ${data.data?.id}', name: 'ApplicationDetailsBloc');
        final loadedState = ApplicationDetailsLoaded(data);
        _lastLoadedState = loadedState;
        emit(loadedState);
      },
    );
  }

  /// Обработчик принятия тикета
  Future<void> _onAcceptTicket(
    AcceptTicketEvent event,
    Emitter<ApplicationDetailsState> emit,
  ) async {
    emit(const ApplicationDetailsAccepting());

    log('=== ACCEPT TICKET ===', name: 'ApplicationDetailsBloc');
    log('Ticket ID: ${event.ticketId}', name: 'ApplicationDetailsBloc');

    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      emit(const ApplicationDetailsError('Нет подключения к интернету'));
      return;
    }

    final result = await _repository.acceptTicket(event.ticketId);

    result.fold(
      (failure) {
        log('=== ACCEPT TICKET ERROR ===', name: 'ApplicationDetailsBloc');
        log('Error: ${failure.message}', name: 'ApplicationDetailsBloc');
        // Эмитим ошибку для показа Toast в listener
        emit(ApplicationDetailsError(failure.message));
        // Сразу возвращаем предыдущее состояние, чтобы не менять UI
        // Listener успеет обработать ошибку перед следующим состоянием
        if (_lastLoadedState != null) {
          emit(_lastLoadedState!);
        }
      },
      (_) {
        log('=== TICKET ACCEPTED ===', name: 'ApplicationDetailsBloc');
        emit(const ApplicationDetailsAccepted());
        // Перезагружаем детали тикета после успешного принятия
        add(LoadTicketDetailsEvent(event.ticketId));
      },
    );
  }

  /// Обработчик отклонения тикета
  Future<void> _onRejectTicket(
    RejectTicketEvent event,
    Emitter<ApplicationDetailsState> emit,
  ) async {
    emit(const ApplicationDetailsRejecting());

    log('=== REJECT TICKET ===', name: 'ApplicationDetailsBloc');
    log('Ticket ID: ${event.ticketId}', name: 'ApplicationDetailsBloc');

    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      emit(const ApplicationDetailsError('Нет подключения к интернету'));
      return;
    }

    final result = await _repository.rejectTicket(
      event.ticketId,
      rejectReason: event.rejectReason,
    );

    result.fold(
      (failure) {
        log('=== REJECT TICKET ERROR ===', name: 'ApplicationDetailsBloc');
        log('Error: ${failure.message}', name: 'ApplicationDetailsBloc');
        // Эмитим ошибку для показа Toast в listener
        emit(ApplicationDetailsError(failure.message));
        // Сразу возвращаем предыдущее состояние, чтобы не менять UI
        // Listener успеет обработать ошибку перед следующим состоянием
        if (_lastLoadedState != null) {
          emit(_lastLoadedState!);
        }
      },
      (_) {
        log('=== TICKET REJECTED ===', name: 'ApplicationDetailsBloc');
        emit(const ApplicationDetailsRejected());
        // Перезагружаем детали тикета после успешного отклонения
        add(LoadTicketDetailsEvent(event.ticketId));
      },
    );
  }

  /// Обработчик назначения исполнителя
  Future<void> _onAssignExecutor(
    AssignExecutorEvent event,
    Emitter<ApplicationDetailsState> emit,
  ) async {
    emit(const ApplicationDetailsAssigningExecutor());

    log('=== ASSIGN EXECUTOR ===', name: 'ApplicationDetailsBloc');
    log('Ticket ID: ${event.ticketId}', name: 'ApplicationDetailsBloc');
    log('Executor ID: ${event.executorId}', name: 'ApplicationDetailsBloc');

    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      emit(const ApplicationDetailsError('Нет подключения к интернету'));
      return;
    }

    final result = await _repository.assignExecutor(
      event.ticketId,
      event.executorId,
    );

    result.fold(
      (failure) {
        log('=== ASSIGN EXECUTOR ERROR ===', name: 'ApplicationDetailsBloc');
        log('Error: ${failure.message}', name: 'ApplicationDetailsBloc');
        // Эмитим ошибку для показа Toast в listener
        emit(ApplicationDetailsError(failure.message));
        // Сразу возвращаем предыдущее состояние, чтобы не менять UI
        // Listener успеет обработать ошибку перед следующим состоянием
        if (_lastLoadedState != null) {
          emit(_lastLoadedState!);
        }
      },
      (_) {
        log('=== EXECUTOR ASSIGNED ===', name: 'ApplicationDetailsBloc');
        emit(const ApplicationDetailsExecutorAssigned());
        // Перезагружаем детали тикета после успешного назначения
        add(LoadTicketDetailsEvent(event.ticketId));
      },
    );
  }
}

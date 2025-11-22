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

    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      emit(const ApplicationDetailsError('Нет подключения к интернету'));
      return;
    }

    final result = await _repository.getTicket(event.ticketId);

    result.fold(
      (failure) {
        log('TicketDetails Error: ${failure.message}', name: 'ApplicationDetailsBloc');
        emit(ApplicationDetailsError(failure.message));
      },
      (data) {
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

    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      emit(const ApplicationDetailsError('Нет подключения к интернету'));
      return;
    }

    final result = await _repository.acceptTicket(event.ticketId);

    result.fold(
      (failure) {
        log('AcceptTicket Error: ${failure.message}', name: 'ApplicationDetailsBloc');
        // Эмитим ошибку для показа Toast в listener
        emit(ApplicationDetailsError(failure.message));
        // Сразу возвращаем предыдущее состояние, чтобы не менять UI
        // Listener успеет обработать ошибку перед следующим состоянием
        if (_lastLoadedState != null) {
          emit(_lastLoadedState!);
        }
      },
      (_) {
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
        log('RejectTicket Error: ${failure.message}', name: 'ApplicationDetailsBloc');
        // Эмитим ошибку для показа Toast в listener
        emit(ApplicationDetailsError(failure.message));
        // Сразу возвращаем предыдущее состояние, чтобы не менять UI
        // Listener успеет обработать ошибку перед следующим состоянием
        if (_lastLoadedState != null) {
          emit(_lastLoadedState!);
        }
      },
      (_) {
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
        log('AssignExecutor Error: ${failure.message}', name: 'ApplicationDetailsBloc');
        // Эмитим ошибку для показа Toast в listener
        emit(ApplicationDetailsError(failure.message));
        // Сразу возвращаем предыдущее состояние, чтобы не менять UI
        // Listener успеет обработать ошибку перед следующим состоянием
        if (_lastLoadedState != null) {
          emit(_lastLoadedState!);
        }
      },
      (_) {
        emit(const ApplicationDetailsExecutorAssigned());
        // Перезагружаем детали тикета после успешного назначения
        add(LoadTicketDetailsEvent(event.ticketId));
      },
    );
  }
}

part of 'application_details_bloc.dart';

abstract class ApplicationDetailsState extends Equatable {
  const ApplicationDetailsState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class ApplicationDetailsInitial extends ApplicationDetailsState {
  const ApplicationDetailsInitial();
}

/// Состояние загрузки
class ApplicationDetailsLoading extends ApplicationDetailsState {
  const ApplicationDetailsLoading();
}

/// Состояние успешной загрузки
class ApplicationDetailsLoaded extends ApplicationDetailsState {
  final GetTicketResponseModel ticket;

  const ApplicationDetailsLoaded(this.ticket);

  @override
  List<Object?> get props => [ticket as Object?];
}

/// Состояние ошибки
class ApplicationDetailsError extends ApplicationDetailsState {
  final String message;

  const ApplicationDetailsError(this.message);

  @override
  List<Object?> get props => [message as Object?];
}

/// Состояние принятия тикета
class ApplicationDetailsAccepting extends ApplicationDetailsState {
  const ApplicationDetailsAccepting();
}

/// Состояние успешного принятия тикета
class ApplicationDetailsAccepted extends ApplicationDetailsState {
  const ApplicationDetailsAccepted();
}

/// Состояние отклонения тикета
class ApplicationDetailsRejecting extends ApplicationDetailsState {
  const ApplicationDetailsRejecting();
}

/// Состояние успешного отклонения тикета
class ApplicationDetailsRejected extends ApplicationDetailsState {
  const ApplicationDetailsRejected();
}

/// Состояние назначения исполнителя
class ApplicationDetailsAssigningExecutor extends ApplicationDetailsState {
  const ApplicationDetailsAssigningExecutor();
}

/// Состояние успешного назначения исполнителя
class ApplicationDetailsExecutorAssigned extends ApplicationDetailsState {
  const ApplicationDetailsExecutorAssigned();
}

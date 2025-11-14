part of 'application_details_bloc.dart';

abstract class ApplicationDetailsEvent extends Equatable {
  const ApplicationDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для загрузки деталей тикета
class LoadTicketDetailsEvent extends ApplicationDetailsEvent {
  final int ticketId;

  const LoadTicketDetailsEvent(this.ticketId);

  @override
  List<Object?> get props => [ticketId as Object?];
}

/// Событие для принятия тикета
class AcceptTicketEvent extends ApplicationDetailsEvent {
  final int ticketId;

  const AcceptTicketEvent(this.ticketId);

  @override
  List<Object?> get props => [ticketId as Object?];
}

/// Событие для отклонения тикета
class RejectTicketEvent extends ApplicationDetailsEvent {
  final int ticketId;
  final String? rejectReason;

  const RejectTicketEvent(this.ticketId, {this.rejectReason});

  @override
  List<Object?> get props => [ticketId as Object?, rejectReason as Object?];
}

/// Событие для назначения исполнителя
class AssignExecutorEvent extends ApplicationDetailsEvent {
  final int ticketId;
  final int executorId;

  const AssignExecutorEvent({
    required this.ticketId,
    required this.executorId,
  });

  @override
  List<Object?> get props => [ticketId as Object?, executorId as Object?];
}

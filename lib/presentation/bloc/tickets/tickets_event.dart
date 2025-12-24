part of 'tickets_bloc.dart';

abstract class TicketsEvent extends Equatable {
  const TicketsEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для загрузки tickets
class LoadTicketsEvent extends TicketsEvent {
  final String? searchText;
  final String? startDate;
  final String? endDate;
  final String? status;
  final String? isEmergency;
  final int? taxTypeId;
  final int? serviceTypeId;
  final int? troubleTypeId;
  final int? priorityTypeId;
  final int? sourceChannelTypeId;
  final int? executorId;
  final int? page;
  final int? perPage;

  const LoadTicketsEvent({
    this.searchText,
    this.startDate,
    this.endDate,
    this.status,
    this.isEmergency,
    this.taxTypeId,
    this.serviceTypeId,
    this.troubleTypeId,
    this.priorityTypeId,
    this.sourceChannelTypeId,
    this.executorId,
    this.page,
    this.perPage,
  });

  @override
  String toString() {
    return 'LoadTicketsEvent{startDate: $startDate, endDate: $endDate, status: $status, isEmergency: $isEmergency, taxTypeId: $taxTypeId, serviceTypeId: $serviceTypeId, troubleTypeId: $troubleTypeId, priorityTypeId: $priorityTypeId, sourceChannelTypeId: $sourceChannelTypeId, executorId: $executorId, page: $page, perPage: $perPage}';
  }

  @override
  List<Object?> get props => [
    searchText,
    startDate,
    endDate,
    status,
    taxTypeId,
    serviceTypeId,
    troubleTypeId,
    priorityTypeId,
    sourceChannelTypeId,
    executorId,
    page,
    perPage,
  ];
}

/// Событие для обновления фильтров
class UpdateTicketsFiltersEvent extends TicketsEvent {
  final String? startDate;
  final String? endDate;
  final String? status;
  final String? isEmergency;
  final int? taxTypeId;
  final int? serviceTypeId;
  final int? troubleTypeId;
  final int? priorityTypeId;
  final int? sourceChannelTypeId;
  final int? executorId;
  final int? page;
  final int? perPage;

  const UpdateTicketsFiltersEvent({
    this.startDate,
    this.endDate,
    this.status,
    this.isEmergency,
    this.taxTypeId,
    this.serviceTypeId,
    this.troubleTypeId,
    this.priorityTypeId,
    this.sourceChannelTypeId,
    this.executorId,
    this.page,
    this.perPage,
  });

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    status,
    isEmergency,
    taxTypeId,
    serviceTypeId,
    troubleTypeId,
    priorityTypeId,
    sourceChannelTypeId,
    executorId,
    page,
    perPage,
  ];
}

/// Событие для сброса фильтров
class ResetTicketsFiltersEvent extends TicketsEvent {
  const ResetTicketsFiltersEvent();
}

/// Событие для обновления списка tickets (pull-to-refresh)
class RefreshTicketsEvent extends TicketsEvent {
  const RefreshTicketsEvent();
}

/// Событие для создания нового тикета
class CreateTicketEvent extends TicketsEvent {
  final CreateTicketParams params;

  const CreateTicketEvent(this.params);

  @override
  List<Object?> get props => [params];
}

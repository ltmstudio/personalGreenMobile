part of 'tickets_bloc.dart';

abstract class TicketsState extends Equatable {
  const TicketsState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class TicketsInitial extends TicketsState {
  const TicketsInitial();
}

/// Состояние загрузки
class TicketsLoading extends TicketsState {
  const TicketsLoading();
}

/// Состояние успешной загрузки
class TicketsLoaded extends TicketsState {
  final List<Ticket> tickets;
  final List<Stat> stats;
  final String? currentStartDate;
  final String? currentEndDate;
  final String? currentStatus;
  final String? currentIsEmergency;
  final int? currentTaxTypeId;
  final int? currentServiceTypeId;
  final int? currentTroubleTypeId;
  final int? currentPriorityTypeId;
  final int? currentSourceChannelTypeId;
  final int? currentPage;
  final int? currentPerPage;

  const TicketsLoaded({
    required this.tickets,
    required this.stats,
    this.currentStartDate,
    this.currentEndDate,
    this.currentStatus,
    this.currentIsEmergency,
    this.currentTaxTypeId,
    this.currentServiceTypeId,
    this.currentTroubleTypeId,
    this.currentPriorityTypeId,
    this.currentSourceChannelTypeId,
    this.currentPage,
    this.currentPerPage,
  });

  @override
  List<Object?> get props => [
    tickets,
    stats,
    currentStartDate,
    currentEndDate,
    currentStatus,
    currentIsEmergency,
    currentTaxTypeId,
    currentServiceTypeId,
    currentTroubleTypeId,
    currentPriorityTypeId,
    currentSourceChannelTypeId,
    currentPage,
    currentPerPage,
  ];

  /// Метод для копирования состояния с обновленными полями
  TicketsLoaded copyWith({
    List<Ticket>? tickets,
    List<Stat>? stats,
    String? currentStartDate,
    String? currentEndDate,
    String? currentStatus,
    String? currentIsEmergency,
    int? currentTaxTypeId,
    int? currentServiceTypeId,
    int? currentTroubleTypeId,
    int? currentPriorityTypeId,
    int? currentSourceChannelTypeId,
    int? currentPage,
    int? currentPerPage,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearStatus = false,
    bool clearIsEmergency = false,
    bool clearTaxTypeId = false,
    bool clearServiceTypeId = false,
    bool clearTroubleTypeId = false,
    bool clearPriorityTypeId = false,
    bool clearSourceChannelTypeId = false,
    bool clearPage = false,
    bool clearPerPage = false,
  }) {
    return TicketsLoaded(
      tickets: tickets ?? this.tickets,
      stats: stats ?? this.stats,
      currentStartDate: clearStartDate
          ? null
          : (currentStartDate ?? this.currentStartDate),
      currentEndDate: clearEndDate
          ? null
          : (currentEndDate ?? this.currentEndDate),
      currentStatus: clearStatus ? null : (currentStatus ?? this.currentStatus),
      currentIsEmergency: clearIsEmergency
          ? null
          : (currentIsEmergency ?? this.currentIsEmergency),
      currentTaxTypeId: clearTaxTypeId
          ? null
          : (currentTaxTypeId ?? this.currentTaxTypeId),
      currentServiceTypeId: clearServiceTypeId
          ? null
          : (currentServiceTypeId ?? this.currentServiceTypeId),
      currentTroubleTypeId: clearTroubleTypeId
          ? null
          : (currentTroubleTypeId ?? this.currentTroubleTypeId),
      currentPriorityTypeId: clearPriorityTypeId
          ? null
          : (currentPriorityTypeId ?? this.currentPriorityTypeId),
      currentSourceChannelTypeId: clearSourceChannelTypeId
          ? null
          : (currentSourceChannelTypeId ?? this.currentSourceChannelTypeId),
      currentPage: clearPage ? null : (currentPage ?? this.currentPage),
      currentPerPage: clearPerPage
          ? null
          : (currentPerPage ?? this.currentPerPage),
    );
  }

  /// Проверка наличия активных фильтров
  bool get hasActiveFilters {
    return currentStartDate != null ||
        currentEndDate != null ||
        currentStatus != null ||
        currentIsEmergency != null ||
        currentTaxTypeId != null ||
        currentServiceTypeId != null ||
        currentTroubleTypeId != null ||
        currentPriorityTypeId != null ||
        currentSourceChannelTypeId != null;
  }

  /// Получение количества активных фильтров
  int get activeFiltersCount {
    int count = 0;
    if (currentStartDate != null) count++;
    if (currentEndDate != null) count++;
    if (currentStatus != null) count++;
    if (currentIsEmergency != null) count++;
    if (currentTaxTypeId != null) count++;
    if (currentServiceTypeId != null) count++;
    if (currentTroubleTypeId != null) count++;
    if (currentPriorityTypeId != null) count++;
    if (currentSourceChannelTypeId != null) count++;
    return count;
  }
}

/// Состояние ошибки
class TicketsError extends TicketsState {
  final String message;

  const TicketsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Состояние пустого списка
class TicketsEmpty extends TicketsState {
  final bool hasFilters;

  const TicketsEmpty({this.hasFilters = false});

  @override
  List<Object?> get props => [hasFilters];
}

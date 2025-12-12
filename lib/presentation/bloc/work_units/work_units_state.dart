part of 'work_units_bloc.dart';

abstract class WorkUnitsState extends Equatable {
  const WorkUnitsState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class WorkUnitsInitial extends WorkUnitsState {
  const WorkUnitsInitial();
}

/// Состояние загрузки
class WorkUnitsLoading extends WorkUnitsState {
  const WorkUnitsLoading();
}

/// Состояние успешной загрузки work_units
class WorkUnitsLoaded extends WorkUnitsState {
  final List<WorkUnit> workUnits;
  final Set<int> selectedIds;

  const WorkUnitsLoaded({
    required this.workUnits,
    required this.selectedIds,
  });

  @override
  List<Object?> get props => [workUnits, selectedIds];
}

/// Состояние ошибки
class WorkUnitsError extends WorkUnitsState {
  final String message;

  const WorkUnitsError(this.message);

  @override
  List<Object?> get props => [message];
}


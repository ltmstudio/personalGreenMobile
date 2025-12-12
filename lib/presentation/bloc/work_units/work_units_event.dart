part of 'work_units_bloc.dart';

abstract class WorkUnitsEvent extends Equatable {
  const WorkUnitsEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для загрузки work_units
class LoadWorkUnitsEvent extends WorkUnitsEvent {
  final List<WorkUnit>? workUnits;

  const LoadWorkUnitsEvent({this.workUnits});

  @override
  List<Object?> get props => [workUnits];
}

/// Событие для переключения чекбокса work_unit
class ToggleWorkUnitEvent extends WorkUnitsEvent {
  final int workUnitId;

  const ToggleWorkUnitEvent({required this.workUnitId});

  @override
  List<Object?> get props => [workUnitId];
}

/// Событие для сброса выбранных work_units
class ResetWorkUnitsEvent extends WorkUnitsEvent {
  const ResetWorkUnitsEvent();
}


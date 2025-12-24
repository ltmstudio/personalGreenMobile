
part of 'work_unit_toggle_cubit.dart';

sealed class WorkUnitsState {}

class WorkUnitsIdle extends WorkUnitsState {}

class WorkUnitsUpdating extends WorkUnitsState {
  final Set<int> ids; // какие пункты сейчас отправляем
  WorkUnitsUpdating(this.ids);
}

class WorkUnitsUpdated extends WorkUnitsState {}

class WorkUnitsError extends WorkUnitsState {
  final String message;
  WorkUnitsError(this.message);
}
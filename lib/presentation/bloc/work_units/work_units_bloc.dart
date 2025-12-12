import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';

part 'work_units_event.dart';
part 'work_units_state.dart';

class WorkUnitsBloc extends Bloc<WorkUnitsEvent, WorkUnitsState> {
  WorkUnitsBloc() : super(const WorkUnitsInitial()) {
    on<LoadWorkUnitsEvent>(_onLoadWorkUnits);
    on<ToggleWorkUnitEvent>(_onToggleWorkUnit);
    on<ResetWorkUnitsEvent>(_onResetWorkUnits);
  }

  /// Обработчик загрузки work_units
  Future<void> _onLoadWorkUnits(
    LoadWorkUnitsEvent event,
    Emitter<WorkUnitsState> emit,
  ) async {
    try {
      final workUnits = event.workUnits ?? [];
      
      if (workUnits.isEmpty) {
        emit(const WorkUnitsLoaded(workUnits: [], selectedIds: {}));
        return;
      }

      // Инициализируем все чекбоксы как не выбранные
      final selectedIds = <int>{};
      
      emit(WorkUnitsLoaded(
        workUnits: workUnits,
        selectedIds: selectedIds,
      ));
    } catch (e) {
      log('LoadWorkUnits Error: $e', name: 'WorkUnitsBloc');
      emit(WorkUnitsError('Ошибка загрузки списка работ'));
    }
  }

  /// Обработчик переключения чекбокса work_unit
  Future<void> _onToggleWorkUnit(
    ToggleWorkUnitEvent event,
    Emitter<WorkUnitsState> emit,
  ) async {
    if (state is WorkUnitsLoaded) {
      final currentState = state as WorkUnitsLoaded;
      final selectedIds = Set<int>.from(currentState.selectedIds);
      
      if (selectedIds.contains(event.workUnitId)) {
        selectedIds.remove(event.workUnitId);
      } else {
        selectedIds.add(event.workUnitId);
      }
      
      emit(WorkUnitsLoaded(
        workUnits: currentState.workUnits,
        selectedIds: selectedIds,
      ));
    }
  }

  /// Обработчик сброса выбранных work_units
  Future<void> _onResetWorkUnits(
    ResetWorkUnitsEvent event,
    Emitter<WorkUnitsState> emit,
  ) async {
    if (state is WorkUnitsLoaded) {
      final currentState = state as WorkUnitsLoaded;
      emit(WorkUnitsLoaded(
        workUnits: currentState.workUnits,
        selectedIds: {},
      ));
    }
  }
}


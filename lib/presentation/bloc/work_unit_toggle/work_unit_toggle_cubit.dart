import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/data/repositories/tickets/tickets_repository.dart';

import '../../../data/models/tickets/ticket_response_model.dart';
part 'work_unit_toggle_state.dart';

class WorkUnitsCubit extends Cubit<WorkUnitsState> {
  final TicketsRepository repo;

  WorkUnitsCubit(this.repo) : super(WorkUnitsIdle());

  Future<void> toggleOne({
    required int ticketId,
    required int workUnitId,
    required bool checked,
  }) async {
    emit(WorkUnitsUpdating({workUnitId}));
    try {
      await repo.toggleWorkUnits(
        ticketId: ticketId,
        items: [ToggleWorkUnitItem(id: workUnitId, checked: checked)],
      );
      emit(WorkUnitsUpdated());
      emit(WorkUnitsIdle());
    } catch (e) {
      emit(WorkUnitsError(e.toString()));
      emit(WorkUnitsIdle());
    }
  }

  Future<void> toggleMany({
    required int ticketId,
    required List<ToggleWorkUnitItem> items,
  }) async {
    emit(WorkUnitsUpdating(items.map((e) => e.id).toSet()));
    try {
      await repo.toggleWorkUnits(ticketId: ticketId, items: items);
      emit(WorkUnitsUpdated());
      emit(WorkUnitsIdle());
    } catch (e) {
      emit(WorkUnitsError(e.toString()));
      emit(WorkUnitsIdle());
    }
  }
}

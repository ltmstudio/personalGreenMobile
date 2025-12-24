import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/data/models/tickets/ticket_report_model.dart';
import 'package:hub_dom/data/repositories/tickets/tickets_repository.dart';

part 'ticket_report_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final TicketsRepository repo;

  ReportsCubit(this.repo) : super(const ReportsState.initial());

  Future<void> load({required int ticketId}) async {
    emit(state.copyWith(status: ReportsStatus.loading, error: null));

    try {
      final items = await repo.getTicketReports(ticketId: ticketId);
      emit(state.copyWith(status: ReportsStatus.success, items: items));
    } catch (e) {
      emit(state.copyWith(status: ReportsStatus.failure, error: e.toString()));
    }
  }
}

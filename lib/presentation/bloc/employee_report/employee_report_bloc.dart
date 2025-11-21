import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/data/models/tickets/employee_report_request_model.dart';
import 'package:hub_dom/data/repositories/tickets/tickets_repository.dart';

part 'employee_report_event.dart';
part 'employee_report_state.dart';

class EmployeeReportBloc extends Bloc<EmployeeReportEvent, EmployeeReportState> {
  final TicketsRepository _repository;

  EmployeeReportBloc(this._repository) : super(const EmployeeReportInitial()) {
    on<SubmitReportEvent>(_onSubmitReport);
  }

  /// Обработчик отправки отчета
  Future<void> _onSubmitReport(
    SubmitReportEvent event,
    Emitter<EmployeeReportState> emit,
  ) async {
    emit(const EmployeeReportSubmitting());

    log('=== SUBMIT REPORT REQUEST ===', name: 'EmployeeReportBloc');
    log('Ticket ID: ${event.ticketId}', name: 'EmployeeReportBloc');
    log('Comment: ${event.request.comment}', name: 'EmployeeReportBloc');
    log('Photos count: ${event.request.photos?.length ?? 0}', name: 'EmployeeReportBloc');

    final result = await _repository.submitReport(event.ticketId, event.request);

    result.fold(
      (failure) {
        log('=== SUBMIT REPORT ERROR ===', name: 'EmployeeReportBloc');
        log('Error: ${failure.message}', name: 'EmployeeReportBloc');
        emit(EmployeeReportError(failure.message));
      },
      (_) {
        log('=== SUBMIT REPORT SUCCESS ===', name: 'EmployeeReportBloc');
        emit(const EmployeeReportSubmitted());
      },
    );
  }
}


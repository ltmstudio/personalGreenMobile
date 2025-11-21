part of 'employee_report_bloc.dart';

abstract class EmployeeReportEvent extends Equatable {
  const EmployeeReportEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для отправки отчета
class SubmitReportEvent extends EmployeeReportEvent {
  final int ticketId;
  final EmployeeReportRequestModel request;

  const SubmitReportEvent({
    required this.ticketId,
    required this.request,
  });

  @override
  List<Object?> get props => [ticketId, request];
}


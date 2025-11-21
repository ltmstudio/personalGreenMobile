part of 'employee_report_bloc.dart';

abstract class EmployeeReportState extends Equatable {
  const EmployeeReportState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class EmployeeReportInitial extends EmployeeReportState {
  const EmployeeReportInitial();
}

/// Состояние отправки отчета
class EmployeeReportSubmitting extends EmployeeReportState {
  const EmployeeReportSubmitting();
}

/// Состояние успешной отправки отчета
class EmployeeReportSubmitted extends EmployeeReportState {
  const EmployeeReportSubmitted();
}

/// Состояние ошибки отправки отчета
class EmployeeReportError extends EmployeeReportState {
  final String message;

  const EmployeeReportError(this.message);

  @override
  List<Object?> get props => [message];
}


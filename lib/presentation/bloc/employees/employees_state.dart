part of 'employees_bloc.dart';

abstract class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class EmployeesInitial extends EmployeesState {
  const EmployeesInitial();
}

/// Состояние загрузки
class EmployeesLoading extends EmployeesState {
  const EmployeesLoading();
}

/// Состояние успешной загрузки
class EmployeesLoaded extends EmployeesState {
  final List<Employee> employees;

  const EmployeesLoaded(this.employees);

  @override
  List<Object?> get props => [employees];
}

/// Состояние ошибки
class EmployeesError extends EmployeesState {
  final String message;

  const EmployeesError(this.message);

  @override
  List<Object?> get props => [message];
}


part of 'employees_bloc.dart';

abstract class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для загрузки employees
class LoadEmployeesEvent extends EmployeesEvent {
  final int? page;
  final int? perPage;
  final bool? withStatistics;

  const LoadEmployeesEvent({
    this.page,
    this.perPage,
    this.withStatistics,
  });

  @override
  List<Object?> get props => [page, perPage, withStatistics];
}

/// Событие для поиска employees
class SearchEmployeesEvent extends EmployeesEvent {
  final String? fullName;
  final int? page;
  final int? perPage;
  final bool? withStatistics;

  const SearchEmployeesEvent({
    this.fullName,
    this.page,
    this.perPage,
    this.withStatistics,
  });

  @override
  List<Object?> get props => [fullName, page, perPage, withStatistics];
}


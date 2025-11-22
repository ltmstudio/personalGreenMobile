import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/network/network.dart';
import 'package:hub_dom/data/models/employees/get_employee_response_model.dart';
import 'package:hub_dom/data/repositories/employees/employees_repository.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final EmployeesRepository _repository;
  final NetworkInfo _networkInfo;

  EmployeesBloc(this._repository, this._networkInfo)
      : super(const EmployeesInitial()) {
    on<LoadEmployeesEvent>(_onLoadEmployees);
    on<SearchEmployeesEvent>(_onSearchEmployees);
  }

  /// Обработчик загрузки employees
  Future<void> _onLoadEmployees(
    LoadEmployeesEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(const EmployeesLoading());

    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      emit(const EmployeesError('Нет подключения к интернету'));
      return;
    }

    final result = await _repository.getEmployees(
      page: event.page,
      perPage: event.perPage,
      withStatistics: event.withStatistics,
    );

    result.fold(
      (failure) {
        log('Employees Error: ${failure.message}', name: 'EmployeesBloc');
        emit(EmployeesError(failure.message));
      },
      (data) {
        emit(EmployeesLoaded(data.data ?? []));
      },
    );
  }

  /// Обработчик поиска employees
  Future<void> _onSearchEmployees(
    SearchEmployeesEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(const EmployeesLoading());

    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      emit(const EmployeesError('Нет подключения к интернету'));
      return;
    }

    final result = await _repository.getEmployees(
      page: event.page,
      perPage: event.perPage,
      fullName: event.fullName,
      withStatistics: event.withStatistics,
    );

    result.fold(
      (failure) {
        // При ошибке поиска (например, 422) показываем пустой список
        // вместо экрана ошибки, так как это не критично
        emit(EmployeesLoaded([]));
      },
      (data) {
        emit(EmployeesLoaded(data.data ?? []));
      },
    );
  }
}


import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/network/network.dart';
import 'package:hub_dom/data/repositories/employees/employees_repository.dart';

part 'is_responsible_state.dart';

class IsResponsibleCubit extends Cubit<IsResponsibleState> {
  IsResponsibleCubit(this._repository, this._networkInfo)
      : super(IsResponsibleInitial());

  final EmployeesRepository _repository;
  final NetworkInfo _networkInfo;

  Future<void> checkIsResponsible() async {
    emit(IsResponsibleLoading());

    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      emit(IsResponsibleError('Нет подключения к интернету'));
      return;
    }

    final result = await _repository.checkIsResponsible();

    result.fold(
      (failure) {
        log('IsResponsible Error: ${failure.message}', name: 'IsResponsibleCubit');
        if (failure is ConnectionFailure) {
          emit(IsResponsibleError('Нет подключения к интернету'));
        } else {
          emit(IsResponsibleError(failure.message));
        }
      },
      (data) {
        final isResponsible = data.data?.isResponsible ?? false;
        emit(IsResponsibleLoaded(isResponsible));
      },
    );
  }
}

import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/network/network.dart';
import 'package:hub_dom/core/local/token_store.dart';
import 'package:hub_dom/data/repositories/employees/employees_repository.dart';
import 'package:hub_dom/locator.dart';

part 'is_responsible_state.dart';

class IsResponsibleCubit extends Cubit<IsResponsibleState> {
  IsResponsibleCubit(this._repository, this._networkInfo)
      : super(IsResponsibleInitial());

  final EmployeesRepository _repository;
  final NetworkInfo _networkInfo;
  final Store _store = locator<Store>();

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
        // При ошибке считаем, что пользователь не ответственный
        final isResponsible = false;
        _store.setIsResponsible(isResponsible);
        if (failure is ConnectionFailure) {
          emit(IsResponsibleError('Нет подключения к интернету'));
        } else {
          emit(IsResponsibleError(failure.message));
        }
      },
      (data) {
        final isResponsible = data.data?.isResponsible ?? false;
        log('IsResponsible loaded: $isResponsible', name: 'IsResponsibleCubit');
        // Сохраняем значение в Store
        _store.setIsResponsible(isResponsible);
        emit(IsResponsibleLoaded(isResponsible));
      },
    );
  }

  void reset() {
    emit(IsResponsibleInitial());
  }
}

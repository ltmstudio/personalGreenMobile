import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/data/models/auth/crm_system_model.dart';
import 'package:hub_dom/data/repositories/auth/auth_repository.dart';

part 'crm_system_state.dart';

class CrmSystemCubit extends Cubit<CrmSystemState> {
  CrmSystemCubit(this.repository) : super(CrmSystemInitial());

  final AuthenticationRepository repository;

  Future<void> getCrmSystems() async {
    emit(CrmSystemLoading());

    final result = await repository.getCrmSystem();

    result.fold(
      (error) {
        if (error is ConnectionFailure) {
          emit(CrmSystemConnectionError());
        } else {
          emit(CrmSystemError());
        }
      },
      (data) {
        emit(CrmSystemLoaded(data));
      },
    );
  }

}

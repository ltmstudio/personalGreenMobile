import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/local/app_prefs.dart';
import 'package:hub_dom/data/models/auth/crm_system_model.dart';
import 'package:hub_dom/data/repositories/auth/auth_repository.dart';
import 'package:hub_dom/locator.dart';

part 'selected_crm_state.dart';

class SelectedCrmCubit extends Cubit<SelectedCrmState> {
  SelectedCrmCubit(this.repository) : super(SelectedCrmInitial());

  final AuthenticationRepository repository;

  Future<void> setCrmSystem(int index) async {
    emit(SelectedCrmLoading());

    final result = await repository.setCrmSystem(index);

    result.fold(
      (error) {
        if (error is ConnectionFailure) {
          emit(SelectedCrmConnectionError());
        } else {
          emit(SelectedCrmError());
        }
      },
      (data) {
        emit(SelectedCrmLoaded(data));
      },
    );
  }

  Future<void> checkCrmSystem() async {
    final isTokenStored = await locator<AppPreferences>().isCrmAvailable();

    if (isTokenStored) {
      emit(SelectedCrmRegistered());
    } else {
      emit(SelectedCrmInitial());
    }
  }
}

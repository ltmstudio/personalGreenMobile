import 'package:bloc/bloc.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/data/models/auth/profile_model.dart';
import 'package:hub_dom/data/models/auth/set_profile_params.dart';
import 'package:hub_dom/data/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'set_profile_state.dart';

class SetProfileCubit extends Cubit<SetProfileState> {
  SetProfileCubit(this.repository) : super(SetProfileInitial());
  final AuthenticationRepository repository;

  Future<void> setProfile(SetProfileParams params) async {
    emit(SetProfileLoading());
    final result = await repository.setProfile(params);

    result.fold(
      (failure) {
        if (failure is ConnectionFailure) {
          emit(SetProfileConnectionError());
        } else {
          emit(SetProfileError());
        }
      },
      (data) {
        emit(SetProfileLoaded(data));
      },
    );
  }
}


import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/local/token_store.dart';
import 'package:hub_dom/data/models/auth/auth_params.dart';
import 'package:hub_dom/data/repositories/auth/auth_repository.dart';
import 'package:hub_dom/locator.dart';

part 'user_auth_event.dart';

part 'user_auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
 final AuthenticationRepository _repository;

  UserAuthBloc(this._repository, )
      : super(UserAuthInitial()) {
    on<LogInEvent>(_onLogIn);
    on<CheckAuthEvent>(_onCheckUser);
   on<LogOutEvent>(_logOut);
    on<InitialEvent>(_onInitialUser);
  }

  void _onLogIn(LogInEvent event, Emitter<UserAuthState> emit) async {
    emit(UserAuthLoading());
    final result = await _repository.login(event.params);
    result.fold(
      (failure) => {emit(UserAuthFailure(failure.message))},
      (data) => {
        emit(UserAuthenticated()),
      },
    );
  }

  Future<void> _onCheckUser(
      CheckAuthEvent event, Emitter<UserAuthState> emit) async {
    final isTokenStored = await locator<Store>().isTokenAvailable();

    if (isTokenStored) {
      emit(UserAuthenticated());
    } else {
      emit(UserAuthInitial());
    }
  }

  Future<void> _onInitialUser(
      InitialEvent event, Emitter<UserAuthState> emit) async {
    emit(UserAuthInitial());
  }

  Future<void> _logOut(LogOutEvent event, Emitter<UserAuthState> emit) async {
    emit(UserAuthLoading());

    final result = await _repository.logout();
    result.fold(
        (failure) => {
              emit(UserAuthFailure(failure.message)),
            },
        (data) => {
              emit(UserAuthInitial()),
            });
  }
}

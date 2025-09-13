part of 'user_auth_bloc.dart';

sealed class UserAuthState extends Equatable {
  @override
  List<Object> get props => [];
}

final class UserAuthInitial extends UserAuthState {}

final class UserAuthLoading extends UserAuthState {}

final class UserAuthenticated extends UserAuthState {}

final class UserAuthFailure extends UserAuthState {
  final String error;

  UserAuthFailure(this.error);

  @override
  List<Object> get props => [error];
}

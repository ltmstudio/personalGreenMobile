part of 'user_auth_bloc.dart';

sealed class UserAuthEvent {}

final class LogInEvent extends UserAuthEvent {
  final LoginParams params;

  LogInEvent(this.params);
}

final class LogOutEvent extends UserAuthEvent {}

final class CheckAuthEvent extends UserAuthEvent {}
final class InitialEvent extends UserAuthEvent {}
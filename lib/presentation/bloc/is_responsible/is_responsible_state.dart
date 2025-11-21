part of 'is_responsible_cubit.dart';

sealed class IsResponsibleState {}

final class IsResponsibleInitial extends IsResponsibleState {}

final class IsResponsibleLoading extends IsResponsibleState {}

final class IsResponsibleLoaded extends IsResponsibleState {
  final bool isResponsible;

  IsResponsibleLoaded(this.isResponsible);
}

final class IsResponsibleError extends IsResponsibleState {
  final String message;

  IsResponsibleError(this.message);
}


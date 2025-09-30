part of 'set_profile_cubit.dart';

@immutable
sealed class SetProfileState {}

final class SetProfileInitial extends SetProfileState {}
final class SetProfileLoading extends SetProfileState {}
final class SetProfileLoaded extends SetProfileState {
  final ProfileModel data;

  SetProfileLoaded(this.data);
}
final class SetProfileError extends SetProfileState {}
final class SetProfileConnectionError extends SetProfileState {}

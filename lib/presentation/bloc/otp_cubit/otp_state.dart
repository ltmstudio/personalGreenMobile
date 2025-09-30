part of 'otp_cubit.dart';

sealed class OtpState {}

final class OtpInitial extends OtpState {}

final class OtpLoading extends OtpState {}

final class OtpLoaded extends OtpState {
  final OtpModel data;

  OtpLoaded({required this.data});
}

final class OtpError extends OtpState {
  final int code;
  final String message;

  OtpError( this.code,  this.message);
}

final class OtpConnectionError extends OtpState {}

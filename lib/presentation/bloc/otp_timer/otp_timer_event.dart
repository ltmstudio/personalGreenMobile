
part of 'otp_timer_bloc.dart';

sealed class OtpTimerEvent {}

class OtpTimerStartedEvent extends OtpTimerEvent {
  final int minutes;
  final int seconds;

  OtpTimerStartedEvent({required this.minutes, required this.seconds});
}

class OtpTimerTickedEvent extends OtpTimerEvent {
  final int minutes;
  final int seconds;

  OtpTimerTickedEvent({required this.minutes, required this.seconds});
}

class OtpTimerStopEvent extends OtpTimerEvent {

  OtpTimerStopEvent();
}

part of 'otp_timer_bloc.dart';

sealed class OtpTimerState extends Equatable {
  final int minutes;
  final int seconds;

  const OtpTimerState({required this.minutes, required this.seconds});

  @override
  List<Object> get props => [minutes, seconds];

}

final class OtpTimerInitial extends OtpTimerState {
  const OtpTimerInitial({required super.minutes, required super.seconds});
}


final class OtpTimerProgress extends OtpTimerState {
  const OtpTimerProgress({required super.minutes, required super.seconds});
}

final class OtpTimeOver extends OtpTimerState {
  const OtpTimeOver({required super.minutes, required super.seconds});
}

final class OtpTimeSuccess extends OtpTimerState {
  const OtpTimeSuccess({required super.minutes, required super.seconds});
}


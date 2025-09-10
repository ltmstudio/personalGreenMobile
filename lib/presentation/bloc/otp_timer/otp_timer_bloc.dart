import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/utils/time_ticker.dart';

part 'otp_timer_event.dart';

part 'otp_timer_state.dart';

class OtpTimerBloc extends Bloc<OtpTimerEvent, OtpTimerState> {
  final TimeTicker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  OtpTimerBloc({required TimeTicker ticker})
      : _ticker = ticker,
        super(const OtpTimerInitial(minutes: 2, seconds: 0)) {
    on<OtpTimerStartedEvent>(_onStarted);
    on<OtpTimerTickedEvent>(_onTicked);
    on<OtpTimerStopEvent>(_onReset);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(OtpTimerStartedEvent event, Emitter<OtpTimerState> emit) {
    emit(OtpTimerProgress(minutes: event.minutes, seconds: event.seconds));
    _tickerSubscription?.cancel();

    int totalSeconds = event.minutes * 60 + event.seconds;
    _tickerSubscription =
        _ticker.tickSecond(ticks: totalSeconds).listen((remainingSeconds) {
      final minutes = remainingSeconds ~/ 60;
      final seconds = remainingSeconds % 60;
      add(OtpTimerTickedEvent(minutes: minutes, seconds: seconds));
    });
  }

  void _onTicked(OtpTimerTickedEvent event, Emitter<OtpTimerState> emit) {
    if (event.minutes == 0 && event.seconds == 0) {
      emit(const OtpTimeOver(minutes: 0, seconds: 0));
      _tickerSubscription?.cancel();
    } else {
      emit(OtpTimerProgress(minutes: event.minutes, seconds: event.seconds));
    }
  }

  void _onReset(OtpTimerStopEvent event, Emitter<OtpTimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const OtpTimerInitial(minutes: 2, seconds: 0));
  }
}

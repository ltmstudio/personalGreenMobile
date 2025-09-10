import 'package:get_it/get_it.dart';
import 'package:hub_dom/presentation/bloc/otp_timer/otp_timer_bloc.dart';

import 'core/utils/time_ticker.dart';


final locator = GetIt.instance;
String documentsDir = '';

Future<void> initLocator() async {
  locator.registerLazySingleton<TimeTicker>(
        () => const TimeTicker(),
  );
  locator.registerSingleton(OtpTimerBloc(ticker: locator()));
}
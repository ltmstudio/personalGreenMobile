import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hub_dom/data/datasources/auth/auth_datasource.dart';
import 'package:hub_dom/presentation/bloc/auth_bloc/user_auth_bloc.dart';
import 'package:hub_dom/presentation/bloc/otp_cubit/otp_cubit.dart';
import 'package:hub_dom/presentation/bloc/otp_timer/otp_timer_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/local/token_store.dart';
import 'core/network/api_provider.dart';
import 'core/network/api_provider_impl.dart';
import 'core/network/network.dart';
import 'core/utils/time_ticker.dart';
import 'data/repositories/auth/auth_repository.dart';

final locator = GetIt.instance;
String documentsDir = '';

Future<void> initLocator() async {
  locator.registerLazySingleton<TimeTicker>(() => const TimeTicker());


  ///cache
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  locator.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);
  locator.registerLazySingleton<Store>(() => Store(locator()));

  ///connection
  final internetChecker = InternetConnectionChecker.createInstance(
    addresses: [AddressCheckOption(uri: Uri.parse('https://www.google.com/'))],
  );
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(internetChecker),
  );
  locator.registerFactory<ApiProvider>(() => ApiProviderImpl());

  ///datasources
  locator.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(apiProvider: locator()),
  );

  ///repositories
  locator.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepository(locator(), locator()),
  );

  ///blocs
   locator.registerSingleton(OtpTimerBloc(ticker: locator()));

  locator.registerSingleton(OtpCubit(locator()));

  locator.registerSingleton<UserAuthBloc>(UserAuthBloc(locator()));
  locator<UserAuthBloc>().add(CheckAuthEvent());
}

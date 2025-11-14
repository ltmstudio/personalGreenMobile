import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hub_dom/data/datasources/addresses/addresses_datasource.dart';
import 'package:hub_dom/data/datasources/auth/auth_datasource.dart';
import 'package:hub_dom/data/datasources/employees/employees_datasource.dart';
import 'package:hub_dom/data/datasources/tickets/tickets_datasource.dart';
import 'package:hub_dom/presentation/bloc/auth_bloc/user_auth_bloc.dart';
import 'package:hub_dom/presentation/bloc/crm_system/crm_system_cubit.dart';
import 'package:hub_dom/presentation/bloc/dictionaries/dictionaries_bloc.dart';
import 'package:hub_dom/presentation/bloc/otp_cubit/otp_cubit.dart';
import 'package:hub_dom/presentation/bloc/otp_timer/otp_timer_bloc.dart';
import 'package:hub_dom/presentation/bloc/selected_crm/selected_crm_cubit.dart';
import 'package:hub_dom/presentation/bloc/set_profile/set_profile_cubit.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_bloc.dart';
import 'package:hub_dom/presentation/bloc/application_details/application_details_bloc.dart';
import 'package:hub_dom/presentation/bloc/employees/employees_bloc.dart';
import 'package:hub_dom/presentation/bloc/tickets/tickets_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/local/app_prefs.dart';
import 'core/local/token_store.dart';
import 'core/network/api_provider.dart';
import 'core/network/api_provider_impl.dart';
import 'core/network/network.dart';
import 'core/usecase/addresses/get_addresses_usecase.dart';
import 'core/usecase/tickets/create_ticket_usecase.dart';
import 'core/utils/time_ticker.dart';
import 'data/repositories/addresses/addresses_repository.dart';
import 'data/repositories/auth/auth_repository.dart';
import 'data/repositories/employees/employees_repository.dart';
import 'data/repositories/tickets/tickets_repository.dart';

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
  final sharedPrefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  locator.registerLazySingleton<AppPreferences>(
    () => AppPreferences(locator()),
  );

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
  locator.registerLazySingleton<TicketsRemoteDatasource>(
    () => TicketsRemoteDatasourceImpl(locator()),
  );
  locator.registerLazySingleton<AddressesRemoteDatasource>(
    () => AddressesRemoteDatasourceImpl(apiProvider: locator()),
  );
  locator.registerLazySingleton<EmployeesRemoteDatasource>(
    () => EmployeesRemoteDatasourceImpl(locator()),
  );

  ///repositories
  locator.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepository(locator(), locator()),
  );
  locator.registerLazySingleton<TicketsRepository>(
    () => TicketsRepository(locator(), locator()),
  );
  locator.registerLazySingleton<AddressesRepository>(
    () => AddressesRepository(
      remoteDataSource: locator(),
      networkInfo: locator(),
    ),
  );
  locator.registerLazySingleton<EmployeesRepository>(
    () => EmployeesRepository(locator(), locator()),
  );

  ///usecases
  locator.registerLazySingleton<CreateTicketUseCase>(
    () => CreateTicketUseCase(locator()),
  );
  locator.registerLazySingleton<GetAddressesUseCase>(
    () => GetAddressesUseCase(locator()),
  );

  ///blocs
  locator.registerSingleton(OtpTimerBloc(ticker: locator()));

  locator.registerSingleton(OtpCubit(locator()));

  locator.registerSingleton<UserAuthBloc>(UserAuthBloc(locator()));
  locator<UserAuthBloc>().add(CheckAuthEvent());

  locator.registerSingleton(SetProfileCubit(locator()));
  locator.registerSingleton(CrmSystemCubit(locator()));
  locator.registerSingleton(SelectedCrmCubit(locator()));
  locator<SelectedCrmCubit>().checkCrmSystem();

  locator.registerFactory<TicketsBloc>(() => TicketsBloc(locator(), locator()));
  locator.registerFactory<DictionariesBloc>(() => DictionariesBloc(locator()));
  locator.registerFactory<AddressesBloc>(() => AddressesBloc(locator()));
  locator.registerFactory<ApplicationDetailsBloc>(
    () => ApplicationDetailsBloc(locator(), locator()),
  );
  locator.registerFactory<EmployeesBloc>(
    () => EmployeesBloc(locator(), locator()),
  );
}

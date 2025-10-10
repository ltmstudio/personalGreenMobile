import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:hub_dom/core/usecase/addresses/get_addresses_usecase.dart';
import 'package:hub_dom/core/usecase/usecase.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_event.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_state.dart';

final log = Logger('AddressesBloc');

class AddressesBloc extends Bloc<AddressesEvent, AddressesState> {
  final GetAddressesUseCase _getAddressesUseCase;

  AddressesBloc(this._getAddressesUseCase) : super(const AddressesInitial()) {
    on<LoadAddressesEvent>(_onLoadAddresses);
  }

  /// Обработчик загрузки адресов
  Future<void> _onLoadAddresses(
    LoadAddressesEvent event,
    Emitter<AddressesState> emit,
  ) async {
    print('=== ADDRESSES BLOC: LOAD ADDRESSES START ===');
    emit(const AddressesLoading());
    print('=== ADDRESSES BLOC: EMITTED LOADING STATE ===');

    log.info('=== LOAD ADDRESSES REQUEST ===');

    try {
      final result = await _getAddressesUseCase.execute(NoParams());
      print('=== ADDRESSES BLOC: USE CASE RESULT RECEIVED ===');

      result.fold(
        (failure) {
          print('=== ADDRESSES BLOC: FAILURE ===');
          print('Error: ${failure.message}');
          log.severe('=== LOAD ADDRESSES ERROR ===');
          log.severe('Error: ${failure.message}');
          emit(AddressesError(failure.message));
        },
        (data) {
          print('=== ADDRESSES BLOC: SUCCESS ===');
          print('Addresses count: ${data.data?.length ?? 0}');
          log.info('=== LOAD ADDRESSES SUCCESS ===');
          log.info('Addresses count: ${data.data?.length ?? 0}');
          emit(AddressesLoaded(data));
          print('=== ADDRESSES BLOC: EMITTED LOADED STATE ===');
        },
      );
    } catch (e) {
      print('=== ADDRESSES BLOC: EXCEPTION ===');
      print('Exception: $e');
      emit(AddressesError('Exception: $e'));
    }
  }
}

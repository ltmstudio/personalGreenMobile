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
    emit(const AddressesLoading());

    try {
      final result = await _getAddressesUseCase.execute(NoParams());

      result.fold(
        (failure) {
          log.severe('LoadAddresses Error: ${failure.message}');
          emit(AddressesError('Произошла ошибка'));
        },
        (data) {
          emit(AddressesLoaded(data));
        },
      );
    } catch (e) {
      log.severe('LoadAddresses Exception: $e');
      emit(AddressesError('Exception: $e'));
    }
  }
}

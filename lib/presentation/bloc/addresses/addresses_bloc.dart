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
    on<LoadMoreAddressesEvent>(_onLoadMoreAddresses);
    on<SearchAddressesEvent>(_onSearchAddresses);
    on<ResetAddressesEvent>(_onResetAddresses);
  }

  Future<void> _onLoadAddresses(
      LoadAddressesEvent event,
      Emitter<AddressesState> emit,
      ) async {
    emit(const AddressesLoading());

    try {
      final result = await _getAddressesUseCase.execute(
        AddressParams(page: event.page, search: event.search),
      );

      result.fold(
            (failure) {
          log.severe('LoadAddresses Error: ${failure.message}');
          emit(const AddressesError('Произошла ошибка'));
        },
            (data) {
          emit(AddressesLoaded(
            addresses: data.data ?? [],
            meta: data.meta,
            searchQuery: event.search,
          ));
        },
      );
    } catch (e) {
      log.severe('LoadAddresses Exception: $e');
      emit(AddressesError('Exception: $e'));
    }
  }

  Future<void> _onLoadMoreAddresses(
      LoadMoreAddressesEvent event,
      Emitter<AddressesState> emit,
      ) async {
    if (state is! AddressesLoaded) return;

    final currentState = state as AddressesLoaded;
    if (!currentState.hasMore) return;

    emit(AddressesLoadingMore(
      currentAddresses: currentState.addresses,
      meta: currentState.meta,
      searchQuery: event.search,
    ));

    try {
      final nextPage = currentState.currentPage + 1;
      final result = await _getAddressesUseCase.execute(
        AddressParams(page: nextPage, search: event.search),
      );

      result.fold(
            (failure) {
          log.severe('LoadMoreAddresses Error: ${failure.message}');
          // Return to previous state on error
          emit(AddressesError(
            'Ошибка загрузки данных',
            previousAddresses: currentState.addresses,
            previousMeta: currentState.meta,
          ));
          // Immediately restore previous state
          emit(currentState);
        },
            (data) {
          final newAddresses = data.data ?? [];
          emit(AddressesLoaded(
            addresses: [...currentState.addresses, ...newAddresses],
            meta: data.meta,
            searchQuery: event.search,
          ));
        },
      );
    } catch (e) {
      log.severe('LoadMoreAddresses Exception: $e');
      emit(currentState);
    }
  }

  Future<void> _onSearchAddresses(
      SearchAddressesEvent event,
      Emitter<AddressesState> emit,
      ) async {
    add(LoadAddressesEvent(page: 1, search: event.query.isEmpty ? null : event.query));
  }

  Future<void> _onResetAddresses(
      ResetAddressesEvent event,
      Emitter<AddressesState> emit,
      ) async {
    emit(const AddressesInitial());
  }
}



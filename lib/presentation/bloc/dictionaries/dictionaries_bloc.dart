import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';
import 'package:hub_dom/data/repositories/tickets/tickets_repository.dart';

part 'dictionaries_event.dart';
part 'dictionaries_state.dart';

class DictionariesBloc extends Bloc<DictionariesEvent, DictionariesState> {
  final TicketsRepository _repository;

  DictionariesBloc(this._repository) : super(const DictionariesInitial()) {
    on<LoadDictionariesEvent>(_onLoadDictionaries);
    on<RefreshDictionariesEvent>(_onRefreshDictionaries);
  }

  /// Обработчик загрузки справочников
  Future<void> _onLoadDictionaries(
    LoadDictionariesEvent event,
    Emitter<DictionariesState> emit,
  ) async {
    emit(const DictionariesLoading());

    log('=== DICTIONARIES REQUEST ===', name: 'DictionariesBloc');

    final result = await _repository.getDictionaries();

    result.fold(
      (failure) {
        log('=== DICTIONARIES ERROR ===', name: 'DictionariesBloc');
        log('Error: ${failure.message}', name: 'DictionariesBloc');
        emit(DictionariesError(failure.message));
      },
      (data) {
        log('=== DICTIONARIES RESPONSE ===', name: 'DictionariesBloc');

        final statuses = data.statuses ?? [];
        final taxTypes = data.taxTypes ?? [];
        final serviceTypes = data.serviceTypes ?? [];
        final troubleTypes = data.troubleTypes ?? [];
        final priorityTypes = data.priorityTypes ?? [];
        final sourceChannelTypes = data.sourceChannelTypes ?? [];

        log('Statuses count: ${statuses.length}', name: 'DictionariesBloc');
        log('Tax Types count: ${taxTypes.length}', name: 'DictionariesBloc');
        log(
          'Service Types count: ${serviceTypes.length}',
          name: 'DictionariesBloc',
        );
        log(
          'Trouble Types count: ${troubleTypes.length}',
          name: 'DictionariesBloc',
        );
        log(
          'Priority Types count: ${priorityTypes.length}',
          name: 'DictionariesBloc',
        );
        log(
          'Source Channel Types count: ${sourceChannelTypes.length}',
          name: 'DictionariesBloc',
        );

        emit(DictionariesLoaded(dictionaries: data));
      },
    );
  }

  /// Обработчик обновления справочников (pull-to-refresh)
  Future<void> _onRefreshDictionaries(
    RefreshDictionariesEvent event,
    Emitter<DictionariesState> emit,
  ) async {
    add(const LoadDictionariesEvent());
  }
}

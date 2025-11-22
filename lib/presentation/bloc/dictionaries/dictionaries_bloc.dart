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

    final result = await _repository.getDictionaries();

    result.fold(
      (failure) {
        log('Dictionaries Error: ${failure.message}', name: 'DictionariesBloc');
        emit(DictionariesError(failure.message));
      },
      (data) {
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

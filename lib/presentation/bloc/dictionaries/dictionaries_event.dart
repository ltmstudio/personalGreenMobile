part of 'dictionaries_bloc.dart';

abstract class DictionariesEvent extends Equatable {
  const DictionariesEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для загрузки справочников
class LoadDictionariesEvent extends DictionariesEvent {
  const LoadDictionariesEvent();
}

/// Событие для обновления справочников (pull-to-refresh)
class RefreshDictionariesEvent extends DictionariesEvent {
  const RefreshDictionariesEvent();
}

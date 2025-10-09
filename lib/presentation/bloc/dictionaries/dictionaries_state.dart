part of 'dictionaries_bloc.dart';

abstract class DictionariesState extends Equatable {
  const DictionariesState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class DictionariesInitial extends DictionariesState {
  const DictionariesInitial();
}

/// Состояние загрузки
class DictionariesLoading extends DictionariesState {
  const DictionariesLoading();
}

/// Состояние успешной загрузки
class DictionariesLoaded extends DictionariesState {
  final DictionaryModel dictionaries;

  const DictionariesLoaded({required this.dictionaries});

  @override
  List<Object?> get props => [dictionaries];

  /// Метод для копирования состояния с обновленными полями
  DictionariesLoaded copyWith({DictionaryModel? dictionaries}) {
    return DictionariesLoaded(dictionaries: dictionaries ?? this.dictionaries);
  }
}

/// Состояние ошибки
class DictionariesError extends DictionariesState {
  final String message;

  const DictionariesError(this.message);

  @override
  List<Object?> get props => [message];
}

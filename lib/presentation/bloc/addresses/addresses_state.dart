import 'package:equatable/equatable.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';

abstract class AddressesState extends Equatable {
  const AddressesState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class AddressesInitial extends AddressesState {
  const AddressesInitial();
}

/// Состояние загрузки адресов
class AddressesLoading extends AddressesState {
  const AddressesLoading();
}

/// Состояние успешной загрузки адресов
class AddressesLoaded extends AddressesState {
  final AddressesResponseModel addresses;

  const AddressesLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

/// Состояние ошибки загрузки адресов
class AddressesError extends AddressesState {
  final String message;

  const AddressesError(this.message);

  @override
  List<Object?> get props => [message];
}

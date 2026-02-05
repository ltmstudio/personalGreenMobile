import 'package:equatable/equatable.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';

abstract class AddressesState extends Equatable {
  const AddressesState();

  @override
  List<Object?> get props => [];
}

class AddressesInitial extends AddressesState {
  const AddressesInitial();
}

class AddressesLoading extends AddressesState {
  const AddressesLoading();
}

class AddressesLoaded extends AddressesState {
  final List<AddressData> addresses;
  final AddressMeta? meta;
  final String? searchQuery;

  const AddressesLoaded({
    required this.addresses,
    this.meta,
    this.searchQuery,
  });

  bool get hasMore => meta != null && meta!.currentPage! < meta!.lastPage!;
  int get currentPage => meta?.currentPage ?? 1;
  int get totalPages => meta?.lastPage ?? 1;

  @override
  List<Object?> get props => [addresses, meta, searchQuery];

  AddressesLoaded copyWith({
    List<AddressData>? addresses,
    AddressMeta? meta,
    String? searchQuery,
  }) {
    return AddressesLoaded(
      addresses: addresses ?? this.addresses,
      meta: meta ?? this.meta,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AddressesLoadingMore extends AddressesState {
  final List<AddressData> currentAddresses;
  final AddressMeta? meta;
  final String? searchQuery;

  const AddressesLoadingMore({
    required this.currentAddresses,
    this.meta,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [currentAddresses, meta, searchQuery];
}

class AddressesError extends AddressesState {
  final String message;
  final List<AddressData>? previousAddresses;
  final AddressMeta? previousMeta;

  const AddressesError(
      this.message, {
        this.previousAddresses,
        this.previousMeta,
      });

  @override
  List<Object?> get props => [message, previousAddresses, previousMeta];
}

// abstract class AddressesState extends Equatable {
//   const AddressesState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// /// Начальное состояние
// class AddressesInitial extends AddressesState {
//   const AddressesInitial();
// }
//
// /// Состояние загрузки адресов
// class AddressesLoading extends AddressesState {
//   const AddressesLoading();
// }
//
// /// Состояние успешной загрузки адресов
// class AddressesLoaded extends AddressesState {
//   final AddressesResponseModel addresses;
//
//   const AddressesLoaded(this.addresses);
//
//   @override
//   List<Object?> get props => [addresses];
// }
//
// /// Состояние ошибки загрузки адресов
// class AddressesError extends AddressesState {
//   final String message;
//
//   const AddressesError(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }

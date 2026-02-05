abstract class AddressesEvent {
  const AddressesEvent();
}

class LoadAddressesEvent extends AddressesEvent {
  final int page;
  final String? search;

  const LoadAddressesEvent({this.page = 1, this.search});
}

class LoadMoreAddressesEvent extends AddressesEvent {
  final String? search;

  const LoadMoreAddressesEvent({this.search});
}

class SearchAddressesEvent extends AddressesEvent {
  final String query;

  const SearchAddressesEvent(this.query);
}

class ResetAddressesEvent extends AddressesEvent {
  const ResetAddressesEvent();
}
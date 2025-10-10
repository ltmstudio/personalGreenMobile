abstract class AddressesEvent {
  const AddressesEvent();
}

/// Событие для загрузки адресов
class LoadAddressesEvent extends AddressesEvent {
  const LoadAddressesEvent();
}

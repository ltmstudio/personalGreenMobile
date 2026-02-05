import 'package:hub_dom/core/constants/strings/endpoints.dart';
import 'package:hub_dom/core/network/api_provider.dart';
import 'package:hub_dom/core/usecase/addresses/get_addresses_usecase.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';
import 'package:hub_dom/data/models/contacts_model.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_bloc.dart';
import 'package:logging/logging.dart';

final log = Logger('AddressesDatasource');

abstract class AddressesRemoteDatasource {
  Future<AddressesResponseModel> getAddresses(AddressParams params);
  Future<List<ContactsModel>> getContacts();
}

class AddressesRemoteDatasourceImpl implements AddressesRemoteDatasource {
  final ApiProvider apiProvider;

  AddressesRemoteDatasourceImpl({required this.apiProvider});

  @override
  Future<AddressesResponseModel> getAddresses(AddressParams params) async {
    try {
      final response = await apiProvider.get(
        endPoint: ApiEndpoints.addresses,
        query: params.toQueryParameters(),
      );
      final result = AddressesResponseModel.fromJson(response.data);
      return result;
    } catch (e) {
      log.severe('GetAddresses Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<ContactsModel>> getContacts() async {
    try {
      final response = await apiProvider.get(
        endPoint: ApiEndpoints.contacts,
      );

      return (response.data as List)
          .map((e) => ContactsModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log.severe('GetContacts Error: $e');
      rethrow;
    }
  }

}

import 'package:hub_dom/core/constants/strings/endpoints.dart';
import 'package:hub_dom/core/network/api_provider.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';
import 'package:logging/logging.dart';

final log = Logger('AddressesDatasource');

abstract class AddressesRemoteDatasource {
  Future<AddressesResponseModel> getAddresses();
}

class AddressesRemoteDatasourceImpl implements AddressesRemoteDatasource {
  final ApiProvider apiProvider;

  AddressesRemoteDatasourceImpl({required this.apiProvider});

  @override
  Future<AddressesResponseModel> getAddresses() async {
    try {
      final response = await apiProvider.get(endPoint: ApiEndpoints.addresses);
      final result = AddressesResponseModel.fromJson(response.data);
      return result;
    } catch (e) {
      log.severe('GetAddresses Error: $e');
      rethrow;
    }
  }
}

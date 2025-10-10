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
    print('=== ADDRESSES DATASOURCE: START ===');
    log.info('=== ADDRESSES REQUEST ===');
    log.info('Endpoint: ${ApiEndpoints.addresses}');
    print('Endpoint: ${ApiEndpoints.addresses}');

    try {
      final response = await apiProvider.get(endPoint: ApiEndpoints.addresses);
      print('=== ADDRESSES DATASOURCE: RESPONSE RECEIVED ===');
      print('Status: ${response.statusCode}');

      log.info('=== ADDRESSES RESPONSE ===');
      log.info('Response status: ${response.statusCode}');
      log.info('Response data: ${response.data}');

      final result = AddressesResponseModel.fromJson(response.data);
      print('=== ADDRESSES DATASOURCE: MODEL CREATED ===');
      print('Addresses count: ${result.data?.length ?? 0}');
      
      return result;
    } catch (e) {
      print('=== ADDRESSES DATASOURCE: ERROR ===');
      print('Error: $e');
      rethrow;
    }
  }
}

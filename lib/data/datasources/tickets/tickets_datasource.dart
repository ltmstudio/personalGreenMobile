import 'dart:developer';

import 'package:hub_dom/core/constants/strings/endpoints.dart';
import 'package:hub_dom/core/network/api_provider.dart';
import 'package:hub_dom/data/models/tickets/collection_model.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';

abstract class TicketsRemoteDatasource{
  Future<List<CollectionModel>> getCollections();

  Future<DictionaryModel> getDictionaries();

}

class TicketsRemoteDatasourceImpl implements TicketsRemoteDatasource{
  final ApiProvider apiProvider;

  TicketsRemoteDatasourceImpl(this.apiProvider);

  @override
  Future<List<CollectionModel>> getCollections()async {
    final response = await apiProvider.get(
      endPoint: ApiEndpoints.collections,
    );

    log(response.toString(), name: 'response');

    final responseBody = response.data['data'] as List;
    final responseData = responseBody.map((e) => CollectionModel.fromJson(e)).toList();

    return responseData;
  }

  @override
  Future<DictionaryModel> getDictionaries() async{
    final response = await apiProvider.get(
      endPoint: ApiEndpoints.collections,
    );

    log(response.toString(), name: 'response');


    return DictionaryModel.fromJson(response.data);
  }
}
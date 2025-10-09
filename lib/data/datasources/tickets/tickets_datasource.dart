import 'dart:developer';

import 'package:hub_dom/core/constants/strings/endpoints.dart';
import 'package:hub_dom/core/network/api_provider.dart';
import 'package:hub_dom/data/models/tickets/collection_model.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';
import 'package:hub_dom/data/models/tickets/ticket_response_model.dart';

abstract class TicketsRemoteDatasource {
  Future<List<CollectionModel>> getCollections();

  Future<DictionaryModel> getDictionaries();

  Future<TicketResponseModel> getTickets({
    String? startDate,
    String? endDate,
    String? status,
    String? isEmergency,
    int? taxTypeId,
    int? serviceTypeId,
    int? troubleTypeId,
    int? priorityTypeId,
    int? sourceChannelTypeId,
    int? page,
    int? perPage,
  });
}

class TicketsRemoteDatasourceImpl implements TicketsRemoteDatasource {
  final ApiProvider apiProvider;

  TicketsRemoteDatasourceImpl(this.apiProvider);

  @override
  Future<List<CollectionModel>> getCollections() async {
    final response = await apiProvider.get(endPoint: ApiEndpoints.collections);

    log(response.toString(), name: 'response');

    final responseBody = response.data['data'] as List;
    final responseData = responseBody
        .map((e) => CollectionModel.fromJson(e))
        .toList();

    return responseData;
  }

  @override
  Future<DictionaryModel> getDictionaries() async {
    final response = await apiProvider.get(endPoint: ApiEndpoints.dictionaries);

    log(response.toString(), name: 'response');

    return DictionaryModel.fromJson(response.data);
  }

  @override
  Future<TicketResponseModel> getTickets({
    String? startDate,
    String? endDate,
    String? status,
    String? isEmergency,
    int? taxTypeId,
    int? serviceTypeId,
    int? troubleTypeId,
    int? priorityTypeId,
    int? sourceChannelTypeId,
    int? page,
    int? perPage,
  }) async {
    // Формируем query параметры согласно скриншоту API
    final queryParams = <String, dynamic>{};

    // start_date и end_date добавляем только если они не null
    if (startDate != null) {
      queryParams['start_date'] = startDate;
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate;
    }

    // page и per_page всегда присутствуют (как на скриншоте)
    queryParams['page'] = page ?? 1;
    queryParams['per_page'] = perPage ?? 10;

    // Остальные параметры добавляем только если они не null
    if (status != null) {
      queryParams['status'] = status;
    }
    // is_emergency передаем только для экстренных заявок (1)
    // Для обычных заявок (not_emergency) параметр не передаем вообще
    if (isEmergency != null && isEmergency == 'emergency') {
      queryParams['is_emergency'] = 1;
    }
    if (taxTypeId != null) {
      queryParams['tax_type_id'] = taxTypeId;
    }
    if (serviceTypeId != null) {
      queryParams['service_type_id'] = serviceTypeId;
    }
    if (troubleTypeId != null) {
      queryParams['trouble_type_id'] = troubleTypeId;
    }
    if (priorityTypeId != null) {
      queryParams['priority_type_id'] = priorityTypeId;
    }
    if (sourceChannelTypeId != null) {
      queryParams['source_channel_type_id'] = sourceChannelTypeId;
    }

    log('=== API REQUEST ===', name: 'TicketsDatasource');
    log('Endpoint: ${ApiEndpoints.collections}', name: 'TicketsDatasource');
    log('Query params: $queryParams', name: 'TicketsDatasource');

    final response = await apiProvider.get(
      endPoint: ApiEndpoints.collections,
      query: queryParams,
    );

    log('=== API RESPONSE ===', name: 'TicketsDatasource');
    log('Response status: ${response.statusCode}', name: 'TicketsDatasource');
    log('Response data: ${response.data}', name: 'TicketsDatasource');

    return TicketResponseModel.fromJson(response.data);
  }
}

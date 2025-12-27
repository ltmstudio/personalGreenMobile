import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:hub_dom/core/constants/strings/endpoints.dart';
import 'package:hub_dom/core/network/api_provider.dart';
import 'package:hub_dom/core/network/api_provider_impl.dart';
import 'package:hub_dom/data/models/tickets/collection_model.dart';
import 'package:hub_dom/data/models/tickets/create_ticket_request_model.dart';
import 'package:hub_dom/data/models/tickets/create_ticket_response_model.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';
import 'package:hub_dom/data/models/tickets/employee_report_request_model.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/data/models/tickets/ticket_response_model.dart';

import '../../models/tickets/ticket_report_model.dart';

abstract class TicketsRemoteDatasource {
  Future<List<CollectionModel>> getCollections();

  Future<DictionaryModel> getDictionaries();

  Future<TicketResponseModel> getTickets({
    String? search,
    String? startDate,
    String? endDate,
    String? status,
    String? isEmergency,
    int? taxTypeId,
    int? serviceTypeId,
    int? troubleTypeId,
    int? priorityTypeId,
    int? sourceChannelTypeId,
    int? executorId,
    int? page,
    int? perPage,
  });

  Future<CreateTicketResponseModel> createTicket(
    CreateTicketRequestModel request,
  );

  Future<GetTicketResponseModel> getTicket(int ticketId);

  Future<void> acceptTicket(int ticketId);

  Future<void> rejectTicket(int ticketId, {String? rejectReason});

  Future<void> assignExecutor(int ticketId, int executorId);

  Future<void> submitReport(int ticketId, EmployeeReportRequestModel request);

  Future<void> toggleWorkUnits({
    required int ticketId,
    required ToggleWorkUnitsRequest body,
  });

  Future<List<TicketReport>> getTicketReports({required int ticketId});

  Future<void> createTicketReport({
    required int ticketId,
    String? comment,
    List<File>? photos,
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

    log('=== DICTIONARIES API RESPONSE ===', name: 'TicketsDatasource');
    log(response.data.toString(), name: 'TicketsDatasource');

    // Проверяем структуру service_types
    if (response.data != null && response.data['service_types'] != null) {
      log('=== SERVICE TYPES RAW DATA ===', name: 'TicketsDatasource');
      final serviceTypes = response.data['service_types'] as List;
      for (int i = 0; i < serviceTypes.length && i < 3; i++) {
        log('Service $i: ${serviceTypes[i]}', name: 'TicketsDatasource');
      }
    }

    return DictionaryModel.fromJson(response.data);
  }

  @override
  Future<TicketResponseModel> getTickets({
    String? search,
    String? startDate,
    String? endDate,
    String? status,
    String? isEmergency,
    int? taxTypeId,
    int? serviceTypeId,
    int? troubleTypeId,
    int? priorityTypeId,
    int? sourceChannelTypeId,
    int? executorId,
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
    if (executorId != null) {
      queryParams['executor_id'] = executorId;
    }
    if (search != null) {
      queryParams['term'] = search;
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

  @override
  Future<CreateTicketResponseModel> createTicket(
    CreateTicketRequestModel request,
  ) async {
    log('=== CREATE TICKET REQUEST ===', name: 'TicketsDatasource');
    log('Endpoint: ${ApiEndpoints.createTicket}', name: 'TicketsDatasource');

    // Формируем FormData вручную для правильной передачи массива файлов
    final formData = FormData();

    // Добавляем текстовые поля
    formData.fields.add(MapEntry('object_id', request.objectId.toString()));
    formData.fields.add(MapEntry('object_type', request.objectType));
    formData.fields.add(
      MapEntry('service_type_id', request.serviceTypeId.toString()),
    );
    formData.fields.add(
      MapEntry('trouble_type_id', request.troubleTypeId.toString()),
    );
    formData.fields.add(
      MapEntry('priority_type_id', request.priorityTypeId.toString()),
    );
    formData.fields.add(MapEntry('deadlined_at', request.deadlinedAt));
    formData.fields.add(MapEntry('visiting_at', request.visitingAt));
    formData.fields.add(
      MapEntry('is_emergency', request.isEmergency.toString()),
    );
    formData.fields.add(MapEntry('comment', request.comment));

    // Добавляем additional_contact только если он не пустой
    if (request.additionalContact.isNotEmpty) {
      formData.fields.add(
        MapEntry('additional_contact', request.additionalContact),
      );
    }

    // Добавляем executor_id только если он указан
    if (request.executorId != null) {
      formData.fields.add(
        MapEntry('executor_id', request.executorId.toString()),
      );
    }

    // Для массива файлов с ключом photos[] добавляем каждый файл
    if (request.photos != null && request.photos!.isNotEmpty) {
      log('Adding ${request.photos!.length} photos', name: 'TicketsDatasource');
      for (final photo in request.photos!) {
        final fileName = photo.path.split(Platform.pathSeparator).last;
        log('Adding photo: $fileName', name: 'TicketsDatasource');
        formData.files.add(
          MapEntry(
            'photos[]',
            await MultipartFile.fromFile(photo.path, filename: fileName),
          ),
        );
      }
    }

    // Логируем реальные поля FormData
    log('FormData fields:', name: 'TicketsDatasource');
    for (final field in formData.fields) {
      log('  ${field.key}: ${field.value}', name: 'TicketsDatasource');
    }
    log(
      'FormData files count: ${formData.files.length}',
      name: 'TicketsDatasource',
    );
    for (final file in formData.files) {
      log('  ${file.key}: ${file.value.filename}', name: 'TicketsDatasource');
    }

    // Используем прямой вызов Dio через ApiProviderImpl
    // Так как postFormData принимает только Map, а нам нужен готовый FormData
    final impl = apiProvider as ApiProviderImpl;
    impl.dio.options.headers.remove('Content-Type');

    try {
      final response = await impl.dio.post(
        ApiEndpoints.createTicket,
        data: formData,
      );

      log('=== CREATE TICKET RESPONSE ===', name: 'TicketsDatasource');
      log('Response status: ${response.statusCode}', name: 'TicketsDatasource');
      log('Response data: ${response.data}', name: 'TicketsDatasource');

      return CreateTicketResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      log('=== CREATE TICKET ERROR ===', name: 'TicketsDatasource');
      log('Error type: ${e.type}', name: 'TicketsDatasource');
      log('Status code: ${e.response?.statusCode}', name: 'TicketsDatasource');
      log('Error message: ${e.message}', name: 'TicketsDatasource');
      if (e.response != null) {
        log(
          'Error response data: ${e.response?.data}',
          name: 'TicketsDatasource',
        );
        // Пытаемся извлечь детали ошибки валидации
        if (e.response?.data is Map) {
          final errorData = e.response!.data as Map;
          if (errorData.containsKey('errors')) {
            log(
              'Validation errors: ${errorData['errors']}',
              name: 'TicketsDatasource',
            );
          }
          if (errorData.containsKey('message')) {
            log(
              'Error message: ${errorData['message']}',
              name: 'TicketsDatasource',
            );
          }
        }
      }
      rethrow;
    }
  }

  @override
  Future<GetTicketResponseModel> getTicket(int ticketId) async {
    log('=== GET TICKET REQUEST ===', name: 'TicketsDatasource');
    log(
      'Endpoint: ${ApiEndpoints.getTicket}/$ticketId',
      name: 'TicketsDatasource',
    );
    log('Ticket ID: $ticketId', name: 'TicketsDatasource');

    final response = await apiProvider.get(
      endPoint: '${ApiEndpoints.getTicket}/$ticketId',
    );

    log('=== GET TICKET RESPONSE ===', name: 'TicketsDatasource');
    log('Response status: ${response.statusCode}', name: 'TicketsDatasource');
    log('Response data: ${response.data}', name: 'TicketsDatasource');

    return GetTicketResponseModel.fromJson(response.data);
  }

  @override
  Future<void> acceptTicket(int ticketId) async {
    log('=== ACCEPT TICKET REQUEST ===', name: 'TicketsDatasource');
    final endpoint = ApiEndpoints.acceptTicket.replaceAll(
      ':ticket_id',
      ticketId.toString(),
    );
    log('Endpoint: $endpoint', name: 'TicketsDatasource');
    log('Ticket ID: $ticketId', name: 'TicketsDatasource');

    final response = await apiProvider.post(
      endPoint: endpoint,
      data: <String, dynamic>{},
    );

    log('=== ACCEPT TICKET RESPONSE ===', name: 'TicketsDatasource');
    log('Response status: ${response.statusCode}', name: 'TicketsDatasource');
    log('Response data: ${response.data}', name: 'TicketsDatasource');
  }

  @override
  Future<void> rejectTicket(int ticketId, {String? rejectReason}) async {
    log('=== REJECT TICKET REQUEST ===', name: 'TicketsDatasource');
    final endpoint = ApiEndpoints.rejectTicket.replaceAll(
      ':ticket_id',
      ticketId.toString(),
    );
    log('Endpoint: $endpoint', name: 'TicketsDatasource');
    log('Ticket ID: $ticketId', name: 'TicketsDatasource');
    log('Reject Reason: $rejectReason', name: 'TicketsDatasource');

    final requestBody = <String, dynamic>{};
    if (rejectReason != null && rejectReason.isNotEmpty) {
      requestBody['reject_reason'] = rejectReason;
    }

    log('Request body: $requestBody', name: 'TicketsDatasource');

    final response = await apiProvider.post(
      endPoint: endpoint,
      data: requestBody,
    );

    log('=== REJECT TICKET RESPONSE ===', name: 'TicketsDatasource');
    log('Response status: ${response.statusCode}', name: 'TicketsDatasource');
    log('Response data: ${response.data}', name: 'TicketsDatasource');
  }

  @override
  Future<void> assignExecutor(int ticketId, int executorId) async {
    log('=== ASSIGN EXECUTOR REQUEST ===', name: 'TicketsDatasource');
    final endpoint = ApiEndpoints.assignExecutor.replaceAll(
      ':ticket_id',
      ticketId.toString(),
    );
    log('Endpoint: $endpoint', name: 'TicketsDatasource');
    log('Ticket ID: $ticketId', name: 'TicketsDatasource');
    log('Executor ID: $executorId', name: 'TicketsDatasource');

    final requestBody = {'executor_id': executorId};
    log('Request body: $requestBody', name: 'TicketsDatasource');

    final response = await apiProvider.post(
      endPoint: endpoint,
      data: requestBody,
    );

    log('=== ASSIGN EXECUTOR RESPONSE ===', name: 'TicketsDatasource');
    log('Response status: ${response.statusCode}', name: 'TicketsDatasource');
    log('Response data: ${response.data}', name: 'TicketsDatasource');
  }

  @override
  Future<void> submitReport(
    int ticketId,
    EmployeeReportRequestModel request,
  ) async {
    log('=== SUBMIT REPORT REQUEST ===', name: 'TicketsDatasource');
    final endpoint = ApiEndpoints.reportTicket.replaceAll(
      ':ticket_id',
      ticketId.toString(),
    );
    log('Endpoint: $endpoint', name: 'TicketsDatasource');
    log('Ticket ID: $ticketId', name: 'TicketsDatasource');
    log('Comment: ${request.comment}', name: 'TicketsDatasource');
    log(
      'Photos count: ${request.photos?.length ?? 0}',
      name: 'TicketsDatasource',
    );

    // Формируем FormData вручную для правильной передачи массива файлов
    final formData = FormData();

    if (request.comment != null && request.comment!.isNotEmpty) {
      formData.fields.add(MapEntry('comment', request.comment!));
    }

    // Для массива файлов с ключом photos[] добавляем каждый файл
    if (request.photos != null && request.photos!.isNotEmpty) {
      for (final photo in request.photos!) {
        final fileName = photo.path.split('/').last;
        formData.files.add(
          MapEntry(
            'photos[]',
            await MultipartFile.fromFile(photo.path, filename: fileName),
          ),
        );
      }
    }

    // Используем прямой вызов Dio через ApiProviderImpl
    // Так как postFormData принимает только Map, а нам нужен готовый FormData
    final impl = apiProvider as ApiProviderImpl;
    impl.dio.options.headers.remove('Content-Type');

    final response = await impl.dio.post(endpoint, data: formData);

    log('=== SUBMIT REPORT RESPONSE ===', name: 'TicketsDatasource');
    log('Response status: ${response.statusCode}', name: 'TicketsDatasource');
    log('Response data: ${response.data}', name: 'TicketsDatasource');
  }

  @override
  Future<void> toggleWorkUnits({
    required int ticketId,
    required ToggleWorkUnitsRequest body,
  }) async {
    await apiProvider.post(
      data: body.toJson(),
      endPoint: '${ApiEndpoints.getTicket}/$ticketId/toggle_work_units',
    );
  }

  @override
  Future<List<TicketReport>> getTicketReports({required int ticketId})async {
    final res = await apiProvider.get(
        endPoint: '${ApiEndpoints.getTicket}/$ticketId/reports');

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected response format');
    }

    return parseReportsData(data);
  }


  @override
  Future<void> createTicketReport({
    required int ticketId,
    String? comment,
    List<File>? photos,
  }) async {
    final endpoint = ApiEndpoints.reportTicket.replaceAll(
      ':ticket_id',
      ticketId.toString(),
    );

    final formData = FormData();

    if (comment != null && comment.trim().isNotEmpty) {
      formData.fields.add(MapEntry('comment', comment.trim()));
    }

    if (photos != null && photos.isNotEmpty) {
      for (final photo in photos) {
        final fileName = photo.path.split(Platform.pathSeparator).last;
        formData.files.add(
          MapEntry(
            'photos[]',
            await MultipartFile.fromFile(photo.path, filename: fileName),
          ),
        );
      }
    }

    // debug
    log('fields=${formData.fields}', name: 'REPORT');
    log('files=${formData.files.length}', name: 'REPORT');

    final impl = apiProvider as ApiProviderImpl;
    impl.dio.options.headers.remove('Content-Type'); // важно
    await impl.dio.post(endpoint, data: formData);
  }



}

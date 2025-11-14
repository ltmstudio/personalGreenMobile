import 'dart:developer';

import 'package:hub_dom/core/constants/strings/endpoints.dart';
import 'package:hub_dom/core/network/api_provider.dart';
import 'package:hub_dom/data/models/employees/get_employee_response_model.dart';

abstract class EmployeesRemoteDatasource {
  Future<GetEmployeeResponseModel> getEmployees({
    int? page,
    int? perPage,
    String? fullName,
  });
}

class EmployeesRemoteDatasourceImpl implements EmployeesRemoteDatasource {
  final ApiProvider apiProvider;

  EmployeesRemoteDatasourceImpl(this.apiProvider);

  @override
  Future<GetEmployeeResponseModel> getEmployees({
    int? page,
    int? perPage,
    String? fullName,
  }) async {
    final queryParams = <String, dynamic>{};

    if (page != null) {
      queryParams['page'] = page;
    }
    if (perPage != null) {
      queryParams['per_page'] = perPage;
    }
    if (fullName != null && fullName.isNotEmpty) {
      queryParams['full_name'] = fullName;
    }

    log('=== GET EMPLOYEES REQUEST ===', name: 'EmployeesDatasource');
    log('Endpoint: ${ApiEndpoints.employees}', name: 'EmployeesDatasource');
    log('Query params: $queryParams', name: 'EmployeesDatasource');

    final response = await apiProvider.get(
      endPoint: ApiEndpoints.employees,
      query: queryParams,
    );

    log('=== GET EMPLOYEES RESPONSE ===', name: 'EmployeesDatasource');
    log('Response status: ${response.statusCode}', name: 'EmployeesDatasource');
    log('Response data: ${response.data}', name: 'EmployeesDatasource');

    return GetEmployeeResponseModel.fromJson(response.data);
  }
}


import 'package:hub_dom/core/constants/strings/endpoints.dart';
import 'package:hub_dom/core/network/api_provider.dart';
import 'package:hub_dom/data/models/employees/get_employee_response_model.dart';
import 'package:hub_dom/data/models/employees/is_responsible_response_model.dart';

abstract class EmployeesRemoteDatasource {
  Future<GetEmployeeResponseModel> getEmployees({
    int? page,
    int? perPage,
    String? fullName,
    bool? withStatistics,
  });

  Future<IsResponsibleResponseModel> checkIsResponsible();
}

class EmployeesRemoteDatasourceImpl implements EmployeesRemoteDatasource {
  final ApiProvider apiProvider;

  EmployeesRemoteDatasourceImpl(this.apiProvider);

  @override
  Future<GetEmployeeResponseModel> getEmployees({
    int? page,
    int? perPage,
    String? fullName,
    bool? withStatistics,
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
    if (withStatistics != null && withStatistics) {
      queryParams['with_statistics'] = 1;
    }

    final response = await apiProvider.get(
      endPoint: ApiEndpoints.employees,
      query: queryParams,
    );

    return GetEmployeeResponseModel.fromJson(response.data);
  }

  @override
  Future<IsResponsibleResponseModel> checkIsResponsible() async {
    final response = await apiProvider.get(
      endPoint: ApiEndpoints.isResponsible,
    );

    return IsResponsibleResponseModel.fromJson(response.data);
  }
}

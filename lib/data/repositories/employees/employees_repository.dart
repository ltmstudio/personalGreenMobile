import 'package:dartz/dartz.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/network/network.dart';
import 'package:hub_dom/core/utils/error_message_helper.dart';
import 'package:hub_dom/data/datasources/employees/employees_datasource.dart';
import 'package:hub_dom/data/models/employees/get_employee_response_model.dart';

class EmployeesRepository {
  final NetworkInfo networkInfo;
  final EmployeesRemoteDatasource remoteDataSource;

  EmployeesRepository(this.networkInfo, this.remoteDataSource);

  Future<Either<Failure, GetEmployeeResponseModel>> getEmployees({
    int? page,
    int? perPage,
    String? fullName,
  }) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getEmployees(
          page: page,
          perPage: perPage,
          fullName: fullName,
        );
        return Right(response);
      } catch (error) {
        final errorMessage = ErrorMessageHelper.getErrorMessage(error);
        return Left(ServerFailure(errorMessage));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }
}


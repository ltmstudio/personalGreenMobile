import 'package:dartz/dartz.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/network/network.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/data/datasources/addresses/addresses_datasource.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';

class AddressesRepository {
  final AddressesRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;

  AddressesRepository({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, AddressesResponseModel>> getAddresses() async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getAddresses();
        return Right(response);
      } catch (error) {
        return Left(ServerFailure(error.toString()));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }
}

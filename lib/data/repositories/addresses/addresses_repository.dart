import 'package:dartz/dartz.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/network/network.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/usecase/addresses/get_addresses_usecase.dart';
import 'package:hub_dom/data/datasources/addresses/addresses_datasource.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_bloc.dart';

import '../../models/contacts_model.dart';

class AddressesRepository {
  final AddressesRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;

  AddressesRepository({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, AddressesResponseModel>> getAddresses(AddressParams params) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getAddresses(params);
        return Right(response);
      } catch (error) {
        return Left(ServerFailure(error.toString()));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<Either<Failure, List<ContactsModel>>> getContacts() async {
    final bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }

    try {
      final response = await remoteDataSource.getContacts();
      return Right(response);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

}

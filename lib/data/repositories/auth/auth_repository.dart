import 'package:dartz/dartz.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/local/token_store.dart';
import 'package:hub_dom/core/network/network.dart';
import 'package:hub_dom/data/datasources/auth/auth_datasource.dart';
import 'package:hub_dom/data/models/auth/auth_params.dart';
import 'package:hub_dom/data/models/auth/otp_model.dart';
import 'package:hub_dom/locator.dart';

class AuthenticationRepository {
  final NetworkInfo networkInfo;
  final AuthenticationRemoteDataSource remoteDataSource;

  AuthenticationRepository(this.networkInfo, this.remoteDataSource);

  Future<Either<Failure, OtpModel>> sendOtp(int phoneNumber) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.sendOtp(phoneNumber);
        return Right(response);
      } catch (error) {
        return const Left(ServerFailure(''));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<Either<Failure, void>> login(LoginParams params) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.login(params);
        return Right(response);
      } catch (error) {
        return Left(ServerFailure(error.toString()));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      await locator<Store>().clear();
      return right(null);
    } catch (error) {
      return left(CacheFailure('Logout failed: $error'));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/network/network.dart';
import 'package:hub_dom/data/datasources/tickets/tickets_datasource.dart';
import 'package:hub_dom/data/models/tickets/collection_model.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';
import 'package:hub_dom/data/models/tickets/ticket_response_model.dart';

class TicketsRepository {
  final NetworkInfo networkInfo;
  final TicketsRemoteDatasource remoteDataSource;

  TicketsRepository(this.networkInfo, this.remoteDataSource);

  Future<Either<Failure, List<CollectionModel>>> getCollections() async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getCollections();
        return Right(response);
      } catch (error) {
        return Left(ServerFailure(error.toString()));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<Either<Failure, DictionaryModel>> getDictionaries() async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getDictionaries();
        return Right(response);
      } catch (error) {
        return Left(ServerFailure(error.toString()));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<Either<Failure, TicketResponseModel>> getTickets({
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
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getTickets(
          startDate: startDate,
          endDate: endDate,
          status: status,
          isEmergency: isEmergency,
          taxTypeId: taxTypeId,
          serviceTypeId: serviceTypeId,
          troubleTypeId: troubleTypeId,
          priorityTypeId: priorityTypeId,
          sourceChannelTypeId: sourceChannelTypeId,
          page: page,
          perPage: perPage,
        );
        return Right(response);
      } catch (error) {
        return Left(ServerFailure(error.toString()));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }
}

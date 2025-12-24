import 'package:dartz/dartz.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/network/network.dart';
import 'package:hub_dom/core/utils/error_message_helper.dart';
import 'package:hub_dom/data/datasources/tickets/tickets_datasource.dart';
import 'package:hub_dom/data/models/tickets/collection_model.dart';
import 'package:hub_dom/data/models/tickets/create_ticket_request_model.dart';
import 'package:hub_dom/data/models/tickets/create_ticket_response_model.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';
import 'package:hub_dom/data/models/tickets/employee_report_request_model.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/data/models/tickets/ticket_response_model.dart';

import '../../models/tickets/ticket_report_model.dart';

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
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getTickets(
          search:search,
          startDate: startDate,
          endDate: endDate,
          status: status,
          isEmergency: isEmergency,
          taxTypeId: taxTypeId,
          serviceTypeId: serviceTypeId,
          troubleTypeId: troubleTypeId,
          priorityTypeId: priorityTypeId,
          sourceChannelTypeId: sourceChannelTypeId,
          executorId: executorId,
          page: page,
          perPage: perPage,
        );
        return Right(response);
      } catch (error) {
        return Left(ServerFailure('Ошибка сервера'));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<Either<Failure, CreateTicketResponseModel>> createTicket(
    CreateTicketRequestModel request,
  ) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.createTicket(request);
        return Right(response);
      } catch (error) {
        return Left(ServerFailure(error.toString()));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<Either<Failure, GetTicketResponseModel>> getTicket(
    int ticketId,
  ) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getTicket(ticketId);
        return Right(response);
      } catch (error) {
        return Left(ServerFailure(error.toString()));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<Either<Failure, void>> acceptTicket(int ticketId) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        await remoteDataSource.acceptTicket(ticketId);
        return const Right(null);
      } catch (error) {
        final errorMessage = ErrorMessageHelper.getErrorMessage(error);
        return Left(ServerFailure(errorMessage));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<Either<Failure, void>> rejectTicket(
    int ticketId, {
    String? rejectReason,
  }) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        await remoteDataSource.rejectTicket(
          ticketId,
          rejectReason: rejectReason,
        );
        return const Right(null);
      } catch (error) {
        final errorMessage = ErrorMessageHelper.getErrorMessage(error);
        return Left(ServerFailure(errorMessage));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<Either<Failure, void>> assignExecutor(
    int ticketId,
    int executorId,
  ) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        await remoteDataSource.assignExecutor(ticketId, executorId);
        return const Right(null);
      } catch (error) {
        final errorMessage = ErrorMessageHelper.getErrorMessage(error);
        return Left(ServerFailure(errorMessage));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<Either<Failure, void>> submitReport(
    int ticketId,
    EmployeeReportRequestModel request,
  ) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        await remoteDataSource.submitReport(ticketId, request);
        return const Right(null);
      } catch (error) {
        final errorMessage = ErrorMessageHelper.getErrorMessage(error);
        return Left(ServerFailure(errorMessage));
      }
    } else {
      return Left(ConnectionFailure(AppStrings.noInternet));
    }
  }

  Future<void> toggleWorkUnits({
    required int ticketId,
    required List<ToggleWorkUnitItem> items,
  }) async {
    final bool isConnected = await networkInfo.isConnected;
    if (!isConnected) return;
    return remoteDataSource.toggleWorkUnits(
      ticketId: ticketId,
      body: ToggleWorkUnitsRequest(workUnits: items),
    );
  }
  Future<List<TicketReport>> getTicketReports({
    required int ticketId,
  }) async {
    final bool isConnected = await networkInfo.isConnected;
    if (!isConnected) throw AppStrings.noInternet;

    return remoteDataSource.getTicketReports(ticketId: ticketId);

  }
}

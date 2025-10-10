import 'package:dartz/dartz.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/usecase/usecase.dart';
import 'package:hub_dom/data/models/tickets/create_ticket_request_model.dart';
import 'package:hub_dom/data/models/tickets/create_ticket_response_model.dart';
import 'package:hub_dom/data/repositories/tickets/tickets_repository.dart';

class CreateTicketUseCase
    implements
        BaseUseCase<CreateTicketRequestModel, CreateTicketResponseModel> {
  final TicketsRepository repository;

  CreateTicketUseCase(this.repository);

  @override
  Future<Either<Failure, CreateTicketResponseModel>> execute(
    CreateTicketRequestModel input,
  ) async {
    return await repository.createTicket(input);
  }
}

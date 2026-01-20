import 'package:dartz/dartz.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/usecase/usecase.dart';
import 'package:hub_dom/core/utils/formatters/ticket_formatter.dart';
import 'package:hub_dom/core/utils/validators/ticket_validator.dart';
import 'package:hub_dom/data/models/tickets/create_ticket_request_model.dart';
import 'package:hub_dom/data/models/tickets/create_ticket_response_model.dart';
import 'package:hub_dom/data/repositories/tickets/tickets_repository.dart';
import 'create_ticket_params.dart';

class CreateTicketUseCase
    implements BaseUseCase<CreateTicketParams, CreateTicketResponseModel> {
  final TicketsRepository repository;

  CreateTicketUseCase(this.repository);

  @override
  Future<Either<Failure, CreateTicketResponseModel>> execute(
    CreateTicketParams params,
  ) async {
    // Валидация данных с использованием правил валидации
    final validationResult = TicketValidator.validate(
      objectId: params.objectId,
      serviceTypeId: params.serviceTypeId,
      troubleTypeId: params.troubleTypeId,
      priorityTypeId: params.priorityTypeId,
      deadlineDate: params.deadlineDate,
      visitingDateTime: params.visitingDateTime,
      comment: params.comment,
      additionalContact: params.additionalContact,
      executorId: params.executorId,
      photos: params.photos,
    );

    if (!validationResult.isValid) {
      final errorMessage = validationResult.errors.values.join(', ');
      return Left(ValidationFailure(errorMessage));
    }

    // Форматирование данных
    final deadlineFormatted = TicketFormatter.formatDate(params.deadlineDate);
    final visitingFormatted = TicketFormatter.formatDateTime(params.visitingDateTime);

    // Создание модели запроса
    final request = CreateTicketRequestModel(
      objectId: params.objectId,
      objectType: params.objectType,
      serviceTypeId: params.serviceTypeId,
      troubleTypeId: params.troubleTypeId,
      priorityTypeId: params.priorityTypeId,
      deadlinedAt: deadlineFormatted,
      visitingAt: visitingFormatted,
      additionalContact: params.additionalContact ?? '',
      isEmergency: params.isEmergency,
      comment: params.comment,
      photos: params.photos,
      executorId: params.executorId,
      contact: params.contact,
    );

    return await repository.createTicket(request);
  }
}

/// Ошибка валидации
class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}

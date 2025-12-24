import 'dart:io';

/// Параметры для создания заявки
class CreateTicketParams {
  final int objectId;
  final String objectType;
  final int serviceTypeId;
  final int troubleTypeId;
  final int priorityTypeId;
  final DateTime deadlineDate;
  final DateTime visitingDateTime;
  final String comment;
  final String? additionalContact;
  final int isEmergency;
  final List<File>? photos;
  final int? executorId;

  CreateTicketParams({
    required this.objectId,
    required this.objectType,
    required this.serviceTypeId,
    required this.troubleTypeId,
    required this.priorityTypeId,
    required this.deadlineDate,
    required this.visitingDateTime,
    required this.comment,
    this.additionalContact,
    this.isEmergency = 0,
    this.photos,
    this.executorId,
  });

  @override
  String toString() {
    return 'CreateTicketParams{objectId: $objectId, objectType: $objectType, serviceTypeId: $serviceTypeId, troubleTypeId: $troubleTypeId, priorityTypeId: $priorityTypeId, deadlineDate: $deadlineDate, visitingDateTime: $visitingDateTime, comment: $comment, additionalContact: $additionalContact, isEmergency: $isEmergency, photos: $photos, executorId: $executorId}';
  }
}










import 'dart:io';

class CreateTicketRequestModel {
  final int objectId;
  final String objectType;
  final int serviceTypeId;
  final int troubleTypeId;
  final int priorityTypeId;
  final String deadlinedAt;
  final String visitingAt;
  final String additionalContact;
  final int isEmergency;
  final String comment;
  final List<File>? photos;
  final int? executorId;
  final String contact;

  CreateTicketRequestModel({
    required this.objectId,
    required this.objectType,
    required this.serviceTypeId,
    required this.troubleTypeId,
    required this.priorityTypeId,
    required this.deadlinedAt,
    required this.visitingAt,
    required this.additionalContact,
    required this.isEmergency,
    required this.comment,
    required this.contact,
    this.photos,
    this.executorId,
  });

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = {
  //     'object_id': objectId,
  //     'object_type': objectType,
  //     'service_type_id': serviceTypeId,
  //     'trouble_type_id': troubleTypeId,
  //     'priority_type_id': priorityTypeId,
  //     'deadlined_at': deadlinedAt,
  //     'visiting_at': visitingAt,
  //     'additional_contact': additionalContact,
  //     'is_emergency': isEmergency,
  //     'comment': comment,
  //     if (executorId != null) 'executor_id': executorId,
  //   };
  //
  //   return data;
  // }

  // Map<String, dynamic> toFormData() {
  //   final Map<String, dynamic> formData = {
  //     'object_id': objectId,
  //     'object_type': objectType,
  //     'service_type_id': serviceTypeId,
  //     'trouble_type_id': troubleTypeId,
  //     'priority_type_id': priorityTypeId,
  //     'deadlined_at': deadlinedAt,
  //     'visiting_at': visitingAt,
  //     'is_emergency': isEmergency,
  //     'comment': comment,
  //     if (executorId != null) 'executor_id': executorId,
  //   };
  //
  //   // Добавляем additional_contact только если он не пустой
  //   if (additionalContact.isNotEmpty) {
  //     formData['additional_contact'] = additionalContact;
  //   }
  //
  //   // Добавляем фотографии если они есть
  //   if (photos != null && photos!.isNotEmpty) {
  //     for (int i = 0; i < photos!.length; i++) {
  //       formData['photos[$i]'] = photos![i];
  //     }
  //   }
  //
  //   return formData;
  // }
}

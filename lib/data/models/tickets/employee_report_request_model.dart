import 'dart:io';

class EmployeeReportRequestModel {
  final String? comment;
  final List<File>? photos;

  EmployeeReportRequestModel({
    this.comment,
    this.photos,
  });

  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> formData = {};

    // Добавляем комментарий если он есть
    if (comment != null && comment!.isNotEmpty) {
      formData['comment'] = comment;
    }

    // Добавляем фотографии если они есть
    // Согласно API, используется photos[] для массива файлов
    // В Dio FormData, для массива файлов передаем List<File>
    // Dio автоматически создаст массив с ключом photos[]
    if (photos != null && photos!.isNotEmpty) {
      formData['photos[]'] = photos;
    }

    return formData;
  }
}


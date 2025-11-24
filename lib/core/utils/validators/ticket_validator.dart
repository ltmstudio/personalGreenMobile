/// Правила валидации для полей заявки
class TicketValidationRules {
  /// Определяет, какие поля обязательны для создания заявки
  /// Ключ - имя поля, значение - сообщение об ошибке
  static const Map<String, String> requiredFields = {
    'objectId': 'Выберите адрес',
    'serviceTypeId': 'Выберите услугу',
    'troubleTypeId': 'Выберите тип работы',
    'priorityTypeId': 'Выберите категорию срочности',
    'deadlineDate': 'Выберите дату выполнения',
    'visitingDateTime': 'Выберите дату и время визита',
    'comment': 'Введите комментарий',
  };

  /// Опциональные поля (не обязательны, но если заполнены - должны быть валидны)
  static const Map<String, String> optionalFields = {
    'additionalContact': 'Введите полный номер телефона',
    'executorId': 'Выберите исполнителя',
    'photos': 'Загрузите фотографии',
  };

  /// Проверка, является ли поле обязательным
  static bool isRequired(String fieldName) {
    return requiredFields.containsKey(fieldName);
  }

  /// Получить сообщение об ошибке для поля
  static String? getErrorMessage(String fieldName) {
    return requiredFields[fieldName] ?? optionalFields[fieldName];
  }
}

/// Валидатор для создания заявки
class TicketValidator {
  /// Валидация данных для создания заявки
  static ValidationResult validate({
    required int? objectId,
    required int? serviceTypeId,
    required int? troubleTypeId,
    required int? priorityTypeId,
    required DateTime? deadlineDate,
    required DateTime? visitingDateTime,
    required String comment,
    String? additionalContact,
    int? executorId,
    List? photos,
  }) {
    final errors = <String, String>{};

    // Валидация обязательных полей
    if (objectId == null) {
      errors['objectId'] = TicketValidationRules.getErrorMessage('objectId')!;
    }

    if (serviceTypeId == null) {
      errors['serviceTypeId'] = TicketValidationRules.getErrorMessage('serviceTypeId')!;
    }

    if (troubleTypeId == null) {
      errors['troubleTypeId'] = TicketValidationRules.getErrorMessage('troubleTypeId')!;
    }

    if (priorityTypeId == null) {
      errors['priorityTypeId'] = TicketValidationRules.getErrorMessage('priorityTypeId')!;
    }

    if (deadlineDate == null) {
      errors['deadlineDate'] = TicketValidationRules.getErrorMessage('deadlineDate')!;
    }

    if (visitingDateTime == null) {
      errors['visitingDateTime'] = TicketValidationRules.getErrorMessage('visitingDateTime')!;
    }

    if (comment.trim().isEmpty) {
      errors['comment'] = TicketValidationRules.getErrorMessage('comment')!;
    }

    // Валидация опциональных полей (если заполнены)
    if (additionalContact != null && additionalContact.trim().isNotEmpty) {
      final phoneDigits = additionalContact.replaceAll(RegExp(r'[^\d]'), '');
      if (phoneDigits.length < 10) {
        errors['additionalContact'] = TicketValidationRules.getErrorMessage('additionalContact')!;
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Получить список обязательных полей
  static List<String> getRequiredFields() {
    return TicketValidationRules.requiredFields.keys.toList();
  }

  /// Проверить, является ли поле обязательным
  static bool isFieldRequired(String fieldName) {
    return TicketValidationRules.isRequired(fieldName);
  }
}

/// Результат валидации
class ValidationResult {
  final bool isValid;
  final Map<String, String> errors;

  ValidationResult({
    required this.isValid,
    required this.errors,
  });
}


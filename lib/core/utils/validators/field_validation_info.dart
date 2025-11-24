/// Информация о валидации поля
class FieldValidationInfo {
  /// Имя поля
  final String fieldName;
  
  /// Является ли поле обязательным
  final bool isRequired;
  
  /// Сообщение об ошибке, если поле не заполнено
  final String? errorMessage;
  
  /// Функция валидации значения (если поле заполнено)
  final String? Function(String? value)? validator;

  FieldValidationInfo({
    required this.fieldName,
    required this.isRequired,
    this.errorMessage,
    this.validator,
  });
}

/// Конфигурация валидации для создания заявки
class TicketFieldValidationConfig {
  /// Получить информацию о валидации для всех полей
  static Map<String, FieldValidationInfo> getFieldsInfo() {
    return {
      'objectId': FieldValidationInfo(
        fieldName: 'objectId',
        isRequired: true,
        errorMessage: 'Выберите адрес',
      ),
      'serviceTypeId': FieldValidationInfo(
        fieldName: 'serviceTypeId',
        isRequired: true,
        errorMessage: 'Выберите услугу',
      ),
      'troubleTypeId': FieldValidationInfo(
        fieldName: 'troubleTypeId',
        isRequired: true,
        errorMessage: 'Выберите тип работы',
      ),
      'priorityTypeId': FieldValidationInfo(
        fieldName: 'priorityTypeId',
        isRequired: true,
        errorMessage: 'Выберите категорию срочности',
      ),
      'deadlineDate': FieldValidationInfo(
        fieldName: 'deadlineDate',
        isRequired: true,
        errorMessage: 'Выберите дату выполнения',
      ),
      'visitingDateTime': FieldValidationInfo(
        fieldName: 'visitingDateTime',
        isRequired: true,
        errorMessage: 'Выберите дату и время визита',
      ),
      'comment': FieldValidationInfo(
        fieldName: 'comment',
        isRequired: true,
        errorMessage: 'Введите комментарий',
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Введите комментарий';
          }
          return null;
        },
      ),
      'additionalContact': FieldValidationInfo(
        fieldName: 'additionalContact',
        isRequired: false, // Опциональное поле
        errorMessage: 'Введите полный номер телефона',
        validator: (value) {
          // Если поле заполнено, проверяем формат
          if (value != null && value.trim().isNotEmpty) {
            final phoneDigits = value.replaceAll(RegExp(r'[^\d]'), '');
            if (phoneDigits.length < 10) {
              return 'Введите полный номер телефона (10 цифр)';
            }
          }
          return null;
        },
      ),
      'executorId': FieldValidationInfo(
        fieldName: 'executorId',
        isRequired: false, // Опциональное поле
        errorMessage: 'Выберите исполнителя',
      ),
      'photos': FieldValidationInfo(
        fieldName: 'photos',
        isRequired: false, // Опциональное поле
        errorMessage: 'Загрузите фотографии',
      ),
    };
  }

  /// Получить информацию о валидации для конкретного поля
  static FieldValidationInfo? getFieldInfo(String fieldName) {
    return getFieldsInfo()[fieldName];
  }

  /// Получить список обязательных полей
  static List<String> getRequiredFields() {
    return getFieldsInfo()
        .entries
        .where((entry) => entry.value.isRequired)
        .map((entry) => entry.key)
        .toList();
  }

  /// Получить список опциональных полей
  static List<String> getOptionalFields() {
    return getFieldsInfo()
        .entries
        .where((entry) => !entry.value.isRequired)
        .map((entry) => entry.key)
        .toList();
  }
}


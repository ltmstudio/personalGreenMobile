// Пример использования системы валидации в UI

import 'package:hub_dom/core/utils/validators/field_validation_info.dart';
import 'package:hub_dom/core/utils/validators/ticket_validator.dart';

/// Пример использования в UI для проверки обязательности полей
class ExampleUsage {
  /// Проверка, нужно ли показывать красный бордер для поля
  static bool shouldShowErrorBorder(String fieldName, dynamic value) {
    final fieldInfo = TicketFieldValidationConfig.getFieldInfo(fieldName);
    
    if (fieldInfo == null) return false;
    
    // Если поле обязательное и пустое - показываем ошибку
    if (fieldInfo.isRequired) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      if (value is List && value.isEmpty) return true;
    }
    
    // Если поле опциональное, но заполнено - проверяем валидность
    if (!fieldInfo.isRequired && value != null && value.toString().isNotEmpty) {
      if (fieldInfo.validator != null) {
        final error = fieldInfo.validator!(value.toString());
        return error != null;
      }
    }
    
    return false;
  }

  /// Получить сообщение об ошибке для поля
  static String? getFieldErrorMessage(String fieldName, dynamic value) {
    final fieldInfo = TicketFieldValidationConfig.getFieldInfo(fieldName);
    
    if (fieldInfo == null) return null;
    
    // Если поле обязательное и пустое
    if (fieldInfo.isRequired) {
      if (value == null || (value is String && value.trim().isEmpty)) {
        return fieldInfo.errorMessage;
      }
    }
    
    // Если поле опциональное, но заполнено - проверяем валидность
    if (!fieldInfo.isRequired && value != null && value.toString().isNotEmpty) {
      if (fieldInfo.validator != null) {
        return fieldInfo.validator!(value.toString());
      }
    }
    
    return null;
  }

  /// Пример использования в виджете
  /*
  Widget buildTextField(String fieldName, TextEditingController controller) {
    final fieldInfo = TicketFieldValidationConfig.getFieldInfo(fieldName);
    final hasError = shouldShowErrorBorder(fieldName, controller.text);
    final errorMessage = getFieldErrorMessage(fieldName, controller.text);
    
    return KTextField(
      controller: controller,
      borderColor: hasError ? AppColors.red : AppColors.lightGrayBorder,
      // ... другие параметры
    );
  }
  */
}

/// Пример: получение всех обязательных полей для отображения в UI
void exampleGetRequiredFields() {
  // Получить список обязательных полей
  final requiredFields = TicketValidator.getRequiredFields();
  print('Обязательные поля: $requiredFields');
  // Выведет: [objectId, serviceTypeId, troubleTypeId, priorityTypeId, deadlineDate, visitingDateTime, comment]
  
  // Проверить конкретное поле
  final isCommentRequired = TicketValidator.isFieldRequired('comment');
  print('Комментарий обязателен: $isCommentRequired'); // true
  
  final isPhoneRequired = TicketValidator.isFieldRequired('additionalContact');
  print('Телефон обязателен: $isPhoneRequired'); // false
}










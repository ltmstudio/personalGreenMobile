# Система валидации полей

## Описание

Эта система позволяет явно определять, какие поля обязательны для создания заявки, а какие опциональны.

## Использование

### 1. Проверка обязательности поля

```dart
// Проверить, является ли поле обязательным
bool isRequired = TicketValidator.isFieldRequired('comment');
// Вернет true, так как comment - обязательное поле

bool isOptional = TicketValidator.isFieldRequired('additionalContact');
// Вернет false, так как additionalContact - опциональное поле
```

### 2. Получение списка обязательных полей

```dart
// Получить все обязательные поля
List<String> requiredFields = TicketValidator.getRequiredFields();
// Вернет: ['objectId', 'serviceTypeId', 'troubleTypeId', 'priorityTypeId', 'deadlineDate', 'visitingDateTime', 'comment']
```

### 3. Получение информации о валидации поля

```dart
// Получить информацию о конкретном поле
FieldValidationInfo? fieldInfo = TicketFieldValidationConfig.getFieldInfo('comment');

if (fieldInfo != null) {
  print('Поле обязательное: ${fieldInfo.isRequired}');
  print('Сообщение об ошибке: ${fieldInfo.errorMessage}');
}
```

### 4. Использование в UI

```dart
// В UI можно проверить, нужно ли показывать красный бордер
bool shouldShowError = TicketValidator.isFieldRequired('comment') && comment.isEmpty;

// Или получить сообщение об ошибке
String? errorMessage = TicketFieldValidationConfig.getFieldInfo('comment')?.errorMessage;
```

## Добавление новых полей

Чтобы добавить новое поле в валидацию:

1. Добавьте правило в `TicketValidationRules.requiredFields` или `optionalFields`
2. Добавьте информацию о поле в `TicketFieldValidationConfig.getFieldsInfo()`
3. Обновите метод `TicketValidator.validate()` для проверки нового поля

## Структура

- `TicketValidationRules` - определяет обязательные и опциональные поля
- `TicketValidator` - выполняет валидацию данных
- `TicketFieldValidationConfig` - предоставляет детальную информацию о валидации каждого поля
- `FieldValidationInfo` - содержит информацию о валидации конкретного поля






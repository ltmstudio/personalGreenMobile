# DictionariesBloc - Управление справочниками

## Описание

`DictionariesBloc` управляет состоянием справочников приложения (статусы, типы налогов, типы услуг, типы проблем, типы приоритетов и типы каналов источников).

## Использование

### 1. Регистрация в зависимостях

Bloc зарегистрирован в `lib/locator.dart`:

```dart
locator.registerFactory<DictionariesBloc>(() => DictionariesBloc(locator()));
```

### 2. Использование в виджете

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/presentation/bloc/dictionaries/dictionaries_bloc.dart';
import 'package:hub_dom/locator.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<DictionariesBloc>()
        ..add(const LoadDictionariesEvent()),
      child: BlocBuilder<DictionariesBloc, DictionariesState>(
        builder: (context, state) {
          if (state is DictionariesLoading) {
            return const CircularProgressIndicator();
          }
          
          if (state is DictionariesError) {
            return Text('Ошибка: ${state.message}');
          }
          
          if (state is DictionariesLoaded) {
            final dictionaries = state.dictionaries;
            
            // Доступ к справочникам
            final statuses = dictionaries.statuses ?? [];
            final taxTypes = dictionaries.taxTypes ?? [];
            final serviceTypes = dictionaries.serviceTypes ?? [];
            final troubleTypes = dictionaries.troubleTypes ?? [];
            final priorityTypes = dictionaries.priorityTypes ?? [];
            final sourceChannelTypes = dictionaries.sourceChannelTypes ?? [];
            
            // Использование справочников
            return ListView.builder(
              itemCount: serviceTypes.length,
              itemBuilder: (context, index) {
                final serviceType = serviceTypes[index];
                return ListTile(
                  title: Text(serviceType.title ?? ''),
                  subtitle: Text('ID: ${serviceType.id}'),
                );
              },
            );
          }
          
          return const SizedBox();
        },
      ),
    );
  }
}
```

### 3. События (Events)

#### LoadDictionariesEvent
Загружает справочники с сервера:
```dart
context.read<DictionariesBloc>().add(const LoadDictionariesEvent());
```

#### RefreshDictionariesEvent
Обновляет справочники (для pull-to-refresh):
```dart
context.read<DictionariesBloc>().add(const RefreshDictionariesEvent());
```

### 4. Состояния (States)

- **DictionariesInitial** - Начальное состояние
- **DictionariesLoading** - Загрузка справочников
- **DictionariesLoaded** - Справочники успешно загружены
  - `dictionaries: DictionaryModel` - Модель со всеми справочниками
- **DictionariesError** - Ошибка загрузки
  - `message: String` - Сообщение об ошибке

## Структура справочников

### DictionaryModel
Содержит все справочники:
- `statuses: List<StatusModel>?` - Статусы заявок
- `taxTypes: List<Type>?` - Типы налогов
- `serviceTypes: List<ServiceType>?` - Типы услуг
- `troubleTypes: List<TroubleType>?` - Типы проблем
- `priorityTypes: List<Type>?` - Типы приоритетов
- `sourceChannelTypes: List<SourceChannelType>?` - Типы каналов источников

### Модели справочников

#### StatusModel
```dart
class StatusModel {
  final String? name;
  final String? title;
  final String? color;
}
```

#### Type
```dart
class Type {
  final int? id;
  final String? name;
  final String? title;
}
```

#### ServiceType
```dart
class ServiceType {
  final int? id;
  final String? title;
  final ServiceTypeOptions? options;
  final List<TroubleType>? troubleTypes;
}
```

#### ServiceTypeOptions
```dart
class ServiceTypeOptions {
  final bool? clientVisibility;
  final int? rank;
  final String? icon;
}
```

#### TroubleType
```dart
class TroubleType {
  final int? id;
  final String? title;
  final int? serviceTypeId;
  final TroubleTypeOptions? options;
}
```

#### TroubleTypeOptions
```dart
class TroubleTypeOptions {
  final bool? clientVisibility;
  final String? deadlineOffset;
  final int? rank;
  final bool? notify;
}
```

#### SourceChannelType
```dart
class SourceChannelType {
  final int? id;
  final String? title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
}
```

## API Endpoint

Справочники загружаются с endpoint: `engineer_api/dictionaries`

## Пример с фильтрацией

```dart
// Получение типов услуг, видимых для клиента
final visibleServiceTypes = serviceTypes
    .where((type) => type.options?.clientVisibility == true)
    .toList();

// Получение типов проблем по ID типа услуги
final troubleTypesByServiceId = (int serviceId) {
  return troubleTypes
      .where((type) => type.serviceTypeId == serviceId)
      .toList();
};

// Сортировка по рангу
final sortedServiceTypes = [...serviceTypes]
  ..sort((a, b) => 
    (a.options?.rank ?? 0).compareTo(b.options?.rank ?? 0));
```


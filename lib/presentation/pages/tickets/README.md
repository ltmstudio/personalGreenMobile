# Tickets Architecture

## Обзор

Создана полная архитектура для работы с tickets, соблюдающая принципы чистой архитектуры и использующая BLoC для управления состоянием.

## Структура

### 1. Модели (Models)
- `ticket_response_model.dart` - основная модель ответа API с tickets и статистикой

### 2. Data Layer
- `tickets_datasource.dart` - источник данных для работы с API
- `tickets_repository.dart` - репозиторий с бизнес-логикой

### 3. Presentation Layer
- `tickets_bloc.dart` - BLoC для управления состоянием
- `tickets_event.dart` - события для BLoC
- `tickets_state.dart` - состояния BLoC

## Параметры API

Архитектура поддерживает все активные параметры из реального API:

- `object_id` - ID объекта
- `is_emergency` - срочность (not_emergency/emergency)
- `object_type` - тип объекта (space)
- `trouble_type_id` - ID типа проблемы
- `priority_type_id` - ID приоритета
- `deadlined_at` - дата дедлайна
- `visiting_at` - дата визита
- `service_type_id` - ID типа услуги
- `source_channel_type_id` - ID канала источника
- `page` - номер страницы
- `per_page` - количество элементов на странице

## Использование

### 1. Инициализация

```dart
final ticketsBloc = locator<TicketsBloc>();
```

### 2. Загрузка tickets

```dart
// Загрузка с параметрами
ticketsBloc.add(const LoadTicketsEvent(
  objectId: 1,
  isEmergency: 'not_emergency',
  objectType: 'space',
  troubleTypeId: 1,
  priorityTypeId: 2,
  deadlinedAt: '2025-10-28',
  visitingAt: '2025-10-28 17:35:17',
));

// Загрузка без параметров
ticketsBloc.add(const LoadTicketsEvent());
```

### 3. Обновление фильтров

```dart
// Обновление конкретного фильтра
ticketsBloc.add(const UpdateTicketsFiltersEvent(
  priorityTypeId: 1,
));

// Сброс всех фильтров
ticketsBloc.add(const ResetTicketsFiltersEvent());
```

### 4. Обновление данных

```dart
// Pull-to-refresh
ticketsBloc.add(const RefreshTicketsEvent());
```

### 5. Отслеживание состояния

```dart
BlocBuilder<TicketsBloc, TicketsState>(
  bloc: ticketsBloc,
  builder: (context, state) {
    if (state is TicketsLoading) {
      return const CircularProgressIndicator();
    }
    
    if (state is TicketsLoaded) {
      return ListView.builder(
        itemCount: state.tickets.length,
        itemBuilder: (context, index) {
          final ticket = state.tickets[index];
          return TicketCard(ticket: ticket);
        },
      );
    }
    
    if (state is TicketsError) {
      return Text('Ошибка: ${state.message}');
    }
    
    if (state is TicketsEmpty) {
      return const Text('Нет данных');
    }
    
    return const SizedBox.shrink();
  },
)
```

## Состояния

- `TicketsInitial` - начальное состояние
- `TicketsLoading` - загрузка данных
- `TicketsLoaded` - данные загружены успешно
- `TicketsError` - ошибка загрузки
- `TicketsEmpty` - пустой результат

## Вспомогательные методы

```dart
// Получение текущих фильтров
final filters = ticketsBloc.getCurrentFilters();

// Проверка наличия активных фильтров
final hasFilters = ticketsBloc.hasActiveFilters();

// Количество активных фильтров (только в TicketsLoaded)
if (state is TicketsLoaded) {
  final count = state.activeFiltersCount;
}
```

## Пример

Полный пример использования находится в `tickets_example_page.dart`.

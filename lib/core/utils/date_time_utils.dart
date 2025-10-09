import 'package:intl/intl.dart';

class DateTimeUtils {
  /// Форматирует DateTime в строку времени (HH:mm)
  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  /// Форматирует DateTime в строку даты (dd.MM.yyyy)
  static String formatDate(DateTime dateTime) {
    final formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(dateTime);
  }

  /// Форматирует DateTime в строку даты и времени (dd.MM.yyyy, HH:mm)
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd.MM.yyyy, HH:mm');
    return formatter.format(dateTime);
  }

  /// Форматирует DateTime в короткую строку времени для карточек (HH:mm)
  static String formatTimeForCard(DateTime dateTime) {
    return formatTime(dateTime);
  }

  /// Проверяет, является ли дата сегодняшней
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Проверяет, является ли дата вчерашней
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Получает относительное время (сегодня, вчера, или дату)
  static String getRelativeDate(DateTime date) {
    if (isToday(date)) {
      return 'Сегодня';
    } else if (isYesterday(date)) {
      return 'Вчера';
    } else {
      return formatDate(date);
    }
  }
}

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/// Форматтер для данных заявки
class TicketFormatter {
  /// Форматирование даты в формат YYYY-MM-DD
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Форматирование даты и времени в формат YYYY-MM-DD HH:mm:ss
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }

  /// Форматирование телефона из маски в формат +7XXXXXXXXXX
  static String formatPhone(String maskedPhone, MaskTextInputFormatter formatter) {
    final unmaskedPhone = formatter.getUnmaskedText();
    if (unmaskedPhone.length >= 10) {
      return '+7$unmaskedPhone';
    }
    return maskedPhone.trim();
  }

  /// Создание DateTime из даты и времени
  static DateTime? createDateTime(DateTime? date, int? hour, int? minute) {
    if (date == null || hour == null || minute == null) {
      return null;
    }
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}


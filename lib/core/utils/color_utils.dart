import 'package:flutter/material.dart';

class ColorUtils {
  /// Преобразует hex строку в Color
  /// Поддерживает форматы: #RRGGBB, #AARRGGBB, RRGGBB, AARRGGBB
  static Color hexToColor(String hexString) {
    try {
      // Убираем # если есть
      String cleanHex = hexString.replaceAll('#', '');

      // Добавляем FF в начало если нет альфа канала
      if (cleanHex.length == 6) {
        cleanHex = 'FF$cleanHex';
      }

      // Парсим как int с основанием 16
      int colorValue = int.parse(cleanHex, radix: 16);

      return Color(colorValue);
    } catch (e) {
      // Возвращаем серый цвет по умолчанию при ошибке
      return Colors.grey;
    }
  }

  /// Проверяет, является ли цвет светлым
  static bool isLightColor(Color color) {
    // Вычисляем яркость цвета
    double luminance = color.computeLuminance();
    return luminance > 0.5;
  }

  /// Получает контрастный цвет (черный или белый)
  static Color getContrastColor(Color color) {
    return isLightColor(color) ? Colors.black : Colors.white;
  }
}

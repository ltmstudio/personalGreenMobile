import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime? dateTime) {
  final String formattedDate = dateTime != null ? DateFormat('dd.MM.yyyy').format(dateTime) : '';
  return formattedDate;
}

String formatTime(DateTime dateTime) {
  final String formattedTime = DateFormat('HH:mm').format(dateTime);
  return formattedTime;
}

String formatDateTime(DateTime dateTime) {
  final String formattedDate = DateFormat('dd.MM.yyyy').format(dateTime);
  final String formattedTime = DateFormat('HH:mm').format(dateTime);
  return '$formattedDate - $formattedTime';
}

String? formattedDateTime(DateTime? date, TimeOfDay? time) {
  if (date == null || time == null) return null;

  // Combine selected date + selected time into one DateTime
  final combined = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );

  final formattedDate = DateFormat('dd.MM.yyyy').format(combined);
  final formattedTime = DateFormat('HH:mm').format(combined);

  return '$formattedDate - $formattedTime';
}

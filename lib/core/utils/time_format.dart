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

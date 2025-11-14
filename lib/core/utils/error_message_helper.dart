import 'package:dio/dio.dart';

/// Утилита для преобразования ошибок в человеко-понятные сообщения
class ErrorMessageHelper {
  /// Преобразует DioException в понятное сообщение для пользователя
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      
      switch (statusCode) {
        case 400:
          return 'Неверный запрос. Проверьте введенные данные';
        case 401:
          return 'Необходима авторизация. Войдите в систему';
        case 403:
          return 'Доступ запрещен. У вас нет прав для выполнения этого действия';
        case 404:
          return 'Запрашиваемый ресурс не найден';
        case 409:
          return 'Конфликт данных. Возможно, запись уже существует';
        case 422:
          // Пытаемся извлечь более конкретное сообщение из ответа
          final errorMessage = _extractErrorMessageFromResponse(error.response);
          if (errorMessage != null && errorMessage.isNotEmpty) {
            return errorMessage;
          }
          return 'Некорректный запрос. Проверьте введенные данные';
        case 429:
          return 'Слишком много запросов. Попробуйте позже';
        case 500:
          return 'Ошибка сервера. Попробуйте позже';
        case 502:
          return 'Сервер временно недоступен. Попробуйте позже';
        case 503:
          return 'Сервис временно недоступен. Попробуйте позже';
        default:
          // Пытаемся извлечь сообщение из ответа сервера
          final errorMessage = _extractErrorMessageFromResponse(error.response);
          if (errorMessage != null && errorMessage.isNotEmpty) {
            return errorMessage;
          }
          
          if (statusCode != null) {
            return 'Ошибка сервера (код $statusCode). Попробуйте позже';
          }
          
          // Проверяем тип ошибки соединения
          switch (error.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              return 'Превышено время ожидания. Проверьте подключение к интернету';
            case DioExceptionType.badResponse:
              return 'Ошибка сервера. Попробуйте позже';
            case DioExceptionType.cancel:
              return 'Запрос был отменен';
            case DioExceptionType.connectionError:
              return 'Ошибка подключения. Проверьте интернет-соединение';
            default:
              return 'Произошла ошибка. Попробуйте позже';
          }
      }
    }
    
    // Если это строка, возвращаем её
    if (error is String) {
      return error;
    }
    
    // Для других типов ошибок
    final errorString = error.toString();
    if (errorString.contains('SocketException') || 
        errorString.contains('Network is unreachable')) {
      return 'Нет подключения к интернету';
    }
    
    return 'Произошла ошибка. Попробуйте позже';
  }
  
  /// Извлекает сообщение об ошибке из ответа сервера
  static String? _extractErrorMessageFromResponse(Response? response) {
    if (response == null || response.data == null) {
      return null;
    }
    
    try {
      final data = response.data;
      
      // Пытаемся найти сообщение в различных форматах ответа
      if (data is Map<String, dynamic>) {
        // Проверяем различные возможные ключи
        return data['message'] as String? ?? 
               data['error'] as String? ?? 
               data['error_message'] as String? ??
               data['msg'] as String?;
      }
      
      if (data is String) {
        return data;
      }
    } catch (e) {
      // Игнорируем ошибки парсинга
    }
    
    return null;
  }
}


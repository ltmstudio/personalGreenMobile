import 'package:dio/dio.dart';
import 'package:hub_dom/core/constants/strings/endpoints.dart';
import 'api_provider.dart';
import 'dio_interceptor.dart';

class ApiProviderImpl implements ApiProvider {
  final Dio dio;

  ApiProviderImpl() : dio = _initializeDio();

  static Dio _initializeDio() {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
      ),
    );
    // Only the interceptor sets the Authorization header
  //  dio.interceptors.add(TokenInterceptor(dio));
    return dio;
  }

  @override
  Future<Response> get({
    String? baseUrl,
    required String endPoint,
    data,
    query,
    String? token,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    int? timeOut,
    bool isMultiPart = false,
    Options? options,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = Duration(seconds: timeOut);
    }

    dio.options.headers = {
      if (isMultiPart) 'Content-Type': 'application/json',
      if (!isMultiPart) 'Content-Type': 'application/json',
      if (!isMultiPart) 'Accept': 'application/json',
    };

    return await dio.get(
      endPoint,
      queryParameters: query,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
    );
  }

  @override
  Future<Response> post({
    String? baseUrl,
    required String endPoint,
    Map<String, dynamic>? data,
    query,
    String? token,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
    int? timeOut,
    bool isMultiPart = false,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = Duration(seconds: timeOut);
    }

    dio.options.headers = {
      if (isMultiPart) 'Content-Type': 'multipart/form-data',
      if (!isMultiPart) 'Content-Type': 'application/json',
      if (!isMultiPart) 'Accept': 'application/json',
    };

    return await dio.post(
      endPoint,
      data: data,
      queryParameters: query,
      onSendProgress: progressCallback,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response> put({
    String? baseUrl,
    required String endPoint,
    data,
    query,
    String? token,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
    int? timeOut,
    bool isMultipart = false,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = Duration(seconds: timeOut);
    }

    dio.options.headers = {
      if (isMultipart) 'Content-Type': 'multipart/form-data',
      if (!isMultipart) 'Content-Type': 'application/json',
      if (!isMultipart) 'Accept': 'application/json',
    };

    return await dio.put(
      endPoint,
      data: data,
      queryParameters: query,
      onSendProgress: progressCallback,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response> patch({
    String? baseUrl,
    required String endPoint,
    data,
    query,
    String? token,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
    int? timeOut,
    bool isMultipart = false,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = Duration(seconds: timeOut);
    }

    dio.options.headers = {
      if (isMultipart) 'Content-Type': 'multipart/form-data',
      if (!isMultipart) 'Content-Type': 'application/json',
      if (!isMultipart) 'Accept': 'application/json',
    };

    return await dio.patch(
      endPoint,
      data: data,
      queryParameters: query,
      onSendProgress: progressCallback,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response> delete({
    String? baseUrl,
    required String endPoint,
    data,
    query,
    String? token,
    int? timeOut,
    bool isMultiPart = false,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = Duration(seconds: timeOut);
    }

    dio.options.headers = {
      if (isMultiPart) 'Content-Type': 'multipart/form-data',
      if (!isMultiPart) 'Content-Type': 'application/json',
      if (!isMultiPart) 'Accept': 'application/json',
    };

    return await dio.delete(endPoint, data: data, queryParameters: query);
  }
}

import 'package:dio/dio.dart';

abstract class ApiProvider {
  Future<Response> post({
    String? baseUrl,
    required String endPoint,
    Map<String, dynamic> data,
    dynamic query,
    String? token,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
    int? timeOut,
    bool isMultiPart = false,
  });

  Future<Response> get({
    String? baseUrl,
    required String endPoint,
    dynamic data,
    dynamic query,
    String? token,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    int? timeOut,
    bool isMultiPart = false,
    Options? options,
  });

  Future<Response> put({
    String? baseUrl,
    required String endPoint,
    dynamic data,
    dynamic query,
    String? token,
    CancelToken? cancelToken,
    int? timeOut,
    bool isMultipart = false,
  });

  Future<Response> patch({
    String? baseUrl,
    required String endPoint,
    dynamic data,
    dynamic query,
    String? token,
    CancelToken? cancelToken,
    int? timeOut,
    bool isMultipart = false,
  });

  Future<Response> delete({
    String? baseUrl,
    required String endPoint,
    dynamic data,
    dynamic query,
    String? token,
    int? timeOut,
    bool isMultiPart = false,
  });
}

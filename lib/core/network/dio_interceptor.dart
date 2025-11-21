import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/config/routes/widget_keys_str.dart';
import 'package:hub_dom/core/constants/strings/endpoints.dart';
import 'package:hub_dom/core/local/app_prefs.dart';
import 'package:hub_dom/core/local/token_store.dart';
import 'package:hub_dom/locator.dart';

class TokenInterceptor extends Interceptor {
  Dio dio;

  TokenInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final store = locator<Store>();
    final prefs = locator<AppPreferences>();

    // Decide which token to use
    // String? token;
    String? token = await store.getToken();

    String? engineerToken;
    if (options.path.contains(ApiEndpoints.login) ||
        options.path.contains(ApiEndpoints.sendOtp) ||
        options.path.contains(ApiEndpoints.refresh) ||
        options.path.contains(ApiEndpoints.crmAvailable) ||
        options.path.contains(ApiEndpoints.profile) ||
        options.path.contains(ApiEndpoints.logout)) {
      // login/otp/profile/logout use main token and hub URL
      // token = await store.getToken();
      options.baseUrl = ApiEndpoints.baseUrl;
      debugPrint('[TokenInterceptor] Using hub URL: ${options.baseUrl}${options.path}');
    } else {
      // after login, use crm engineerToken + crm baseUrl
      engineerToken = await prefs.getCrmToken();
      String? crmHost = await prefs.getCrmHost();
      if (crmHost != null) {
        // Убеждаемся, что в конце есть слеш
        options.baseUrl = crmHost.endsWith('/') ? crmHost : '$crmHost/';
        debugPrint('[TokenInterceptor] Using CRM URL: ${options.baseUrl}${options.path}');
      } else {
        options.baseUrl = ApiEndpoints.baseUrl;
        debugPrint('[TokenInterceptor] CRM host not found, using hub URL: ${options.baseUrl}${options.path}');
      }

      if (engineerToken != null) {
        options.headers["X-Engineer-Token"] = engineerToken;
      }
    }
    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log the response
    // debugPrint('--- Response ---');
    // debugPrint('Status Code: ${response.statusCode}');
    // debugPrint('URI: ${response.requestOptions.uri}');
    // debugPrint('Headers: ${response.headers}');
    // debugPrint('Data: ${response.data}');
    // debugPrint('----------------');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // debugPrint('--- Error ---');
    // debugPrint('URI: ${err.requestOptions.uri}');
    // debugPrint('Status Code: ${err.response?.statusCode}');
    // debugPrint('Message: ${err.message}');
    // debugPrint('Data: ${err.response?.data}');
    // debugPrint('----------------');

    if (err.response?.statusCode == 401) {
      try {
        await refreshToken();
        RequestOptions options = err.response!.requestOptions;
        String? token = await locator<Store>().getToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
          final response = await dio.fetch(options);
          handler.resolve(response);
          return;
        }
      } catch (e) {
        debugPrint("Failed to refresh token: $e");
        await locator<Store>().clear();
        await locator<AppPreferences>().clearCrm();

        rootNavKey.currentContext!.go(AppRoutes.signIn);
      }
    }
    super.onError(err, handler);
  }

  Future<void> refreshToken() async {
    try {
      String? refreshToken = await locator<Store>().getRefreshToken();

      if (refreshToken != null) {
        var response = await dio.post(
          ApiEndpoints.refresh,
          data: {'refresh_token': refreshToken},
        );

        if (response.statusCode == 200) {
          String newAccessToken = response.data['data']["access_token"];
          String newRefreshToken = response.data['data']["refresh_token"];
          await locator<Store>().setToken(newAccessToken);
          await locator<Store>().setRefreshToken(newRefreshToken);
        } else {
          throw DioException(
            response: Response(
              statusCode: response.statusCode,
              requestOptions: response.requestOptions,
              data: response.data,
              headers: response.headers,
              statusMessage: response.statusMessage,
            ),
            requestOptions: response.requestOptions,
          );
        }
      } else {
        throw Exception("---------Token is null----------");
      }
    } catch (e) {
      throw Exception("------------Failed to refresh token:------------- $e");
    }
  }
}

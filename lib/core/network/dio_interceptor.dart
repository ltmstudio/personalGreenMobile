//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// class TokenInterceptor extends Interceptor {
//   Dio dio;
//
//   TokenInterceptor(this.dio);
//
//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     String? token = await locator<Store>().getToken();
//
//     if (token != null) {
//       options.headers["Authorization"] = "Bearer $token";
//     }
//
//     super.onRequest(options, handler);
//   }
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401) {
//       try {
//         RequestOptions options = err.response!.requestOptions;
//         String? token = await locator<Store>().getToken();
//         if (token != null) {
//           options.headers["Authorization"] = "Bearer $token";
//           final response = await dio.fetch(options);
//           handler.resolve(response);
//           return;
//         }
//       } catch (e) {
//         debugPrint("Failed to refresh token: $e");
//         await locator<Store>().clear();
//
//         rootNavKey.currentContext!.go(AppRoutes.signIn);
//       }
//     }
//     super.onError(err, handler);
//   }
//
//   // @override
//   // void onError(DioException err, ErrorInterceptorHandler handler) async {
//   //   if (err.response?.statusCode == 401) {
//   //     // Token invalid → clear session and redirect to login
//   //     await locator<Store>().clear();
//   //     rootNavKey.currentContext?.go(AppRoutes.signIn);
//   //
//   //     // Optionally reject the request with custom error
//   //     return handler.reject(err);
//   //   }
//   //
//   //   super.onError(err, handler);
//   // }
// }

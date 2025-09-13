import 'dart:developer';
import 'package:hub_dom/core/constants/strings/endpoints.dart';
import 'package:hub_dom/core/local/token_store.dart';
import 'package:hub_dom/core/network/api_provider.dart';
import 'package:hub_dom/data/models/auth/auth_params.dart';
import 'package:hub_dom/data/models/auth/otp_model.dart';
import 'package:hub_dom/locator.dart';

abstract class AuthenticationRemoteDataSource {
  Future<OtpModel> sendOtp(int phoneNumber);

  Future<void> login(LoginParams params);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final ApiProvider apiProvider;

  AuthenticationRemoteDataSourceImpl({required this.apiProvider});

  @override
  Future<OtpModel> sendOtp(int phoneNumber) async {
    log(phoneNumber.toString(), name: 'phone');

    final response = await apiProvider.post(
      endPoint: ApiEndpoints.sendOtp,
      data: {"phone": '+7${phoneNumber.toString()}'},
    );

    log(response.toString(), name: 'response');

    return OtpModel.fromJson(response.data);
  }

  @override
  Future<void> login(LoginParams params) async {

    final response =
    await apiProvider.post(endPoint: ApiEndpoints.login, data: params.toQueryParameters());

    if (response.statusCode == 200) {

      final accessToken = response.data['data']['access_token'];

      final refreshToken = response.data['data']['refresh_token'];

      await locator<Store>().setToken(accessToken);
      await locator<Store>().setRefreshToken(refreshToken);
    } else {
      throw Exception(response.statusCode);
    }
  }
}

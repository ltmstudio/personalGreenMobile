import 'dart:developer';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/endpoints.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/local/app_prefs.dart';
import 'package:hub_dom/core/local/token_store.dart';
import 'package:hub_dom/core/network/api_provider.dart';
import 'package:hub_dom/data/models/auth/auth_params.dart';
import 'package:hub_dom/data/models/auth/crm_system_model.dart';
import 'package:hub_dom/data/models/auth/otp_model.dart';
import 'package:hub_dom/data/models/auth/profile_model.dart';
import 'package:hub_dom/data/models/auth/set_profile_params.dart';
import 'package:hub_dom/locator.dart';

abstract class AuthenticationRemoteDataSource {
  Future<OtpModel> sendOtp(int phoneNumber);

  Future<void> login(LoginParams params);

  Future<List<CrmSystemModel>> getCrmSystem();

  Future<ProfileModel> setProfile(SetProfileParams params);

  Future<CrmSystemModel> setCrmSystem(int index);
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
    switch (response.statusCode) {
      case 200:
        return OtpModel.fromJson(response.data);
      case 429:
        throw OtpFailure(429, AppStrings.tryLater);
      case 409:
        throw OtpFailure(409, AppStrings.loggedInNumber);
      case 423:
        throw OtpFailure(423, AppStrings.loggedInNumber);
      default:
        throw OtpFailure(response.statusCode ?? 500, "Unexpected error.");
    }
  }

  @override
  Future<void> login(LoginParams params) async {
    final response = await apiProvider.post(
      endPoint: ApiEndpoints.login,
      data: params.toQueryParameters(),
    );

    if (response.statusCode == 200) {
      final accessToken = response.data['data']['access_token'];

      final refreshToken = response.data['data']['refresh_token'];

      await locator<Store>().setToken(accessToken);
      await locator<Store>().setRefreshToken(refreshToken);
    } else {
      throw Exception(response.statusCode);
    }
  }

  @override
  Future<List<CrmSystemModel>> getCrmSystem() async {
    final response = await apiProvider.get(endPoint: ApiEndpoints.crmAvailable);

    log(response.toString(), name: 'response');
    final responseBody = response.data['data'] as List;
    final result = responseBody.map((e) => CrmSystemModel.fromJson(e)).toList();

    //todo add token by index
    // await locator<AppPreferences>().setCrmHost(result.crm.host);
    // await locator<AppPreferences>().setCrmName(result.crm.name);
    // await locator<AppPreferences>().setCrmToken(result.token);

    return result;
  }

  @override
  Future<ProfileModel> setProfile(SetProfileParams params) async {
    final response = await apiProvider.post(
      endPoint: ApiEndpoints.profile,
      data: params.toQueryParameters(),
    );

    return ProfileModel.fromJson(response.data['data']);
  }

  @override
  Future<CrmSystemModel> setCrmSystem(int index) async {
    final crmSystems = await getCrmSystem();
    final result = crmSystems[index];

    await locator<AppPreferences>().setCrmHost(result.crm.host);
    await locator<AppPreferences>().setCrmName(result.crm.name);
    await locator<AppPreferences>().setCrmToken(result.token);

    return result;
  }
}

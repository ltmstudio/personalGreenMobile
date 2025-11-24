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

  Future<void> logout();

  Future<ProfileModel> getProfile();

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
  Future<void> logout() async {
    log('=== LOGOUT REQUEST ===', name: 'AuthDatasource');
    log('Endpoint: ${ApiEndpoints.logout}', name: 'AuthDatasource');

    final response = await apiProvider.post(
      endPoint: ApiEndpoints.logout,
      data: <String, dynamic>{},
    );

    log('=== LOGOUT RESPONSE ===', name: 'AuthDatasource');
    log('Response status: ${response.statusCode}', name: 'AuthDatasource');
    log('Response data: ${response.data}', name: 'AuthDatasource');

    if (response.statusCode != 200) {
      throw Exception('Logout failed with status: ${response.statusCode}');
    }
  }

  @override
  Future<ProfileModel> getProfile() async {
    try {
      log('=== GET PROFILE REQUEST ===', name: 'AuthDatasource');
      log('Endpoint: ${ApiEndpoints.profile}', name: 'AuthDatasource');

      final response = await apiProvider.get(
        endPoint: ApiEndpoints.profile,
      );

      log('=== GET PROFILE RESPONSE ===', name: 'AuthDatasource');
      log('Response status: ${response.statusCode}', name: 'AuthDatasource');
      log('Response data type: ${response.data.runtimeType}', name: 'AuthDatasource');
      log('Response data: ${response.data}', name: 'AuthDatasource');
      log('Response data (toString): ${response.data.toString()}', name: 'AuthDatasource');
      
      // Детальное логирование структуры данных
      if (response.data is Map) {
        final dataMap = response.data as Map;
        log('Response keys: ${dataMap.keys.toList()}', name: 'AuthDatasource');
        if (dataMap.containsKey('data')) {
          log('Data field type: ${dataMap['data'].runtimeType}', name: 'AuthDatasource');
          log('Data field: ${dataMap['data']}', name: 'AuthDatasource');
          if (dataMap['data'] is Map) {
            final dataField = dataMap['data'] as Map;
            log('Data field keys: ${dataField.keys.toList()}', name: 'AuthDatasource');
            dataField.forEach((key, value) {
              log('  - $key: $value (${value.runtimeType})', name: 'AuthDatasource');
            });
          }
        }
      }

      if (response.statusCode == 200) {
        final profile = ProfileModel.fromJson(response.data['data']);
        log('Profile parsed successfully: id=${profile.id}, userName=${profile.userName}', name: 'AuthDatasource');
        return profile;
      } else {
        throw Exception('Get profile failed with status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('=== GET PROFILE ERROR ===', name: 'AuthDatasource');
      log('Error: $e', name: 'AuthDatasource');
      log('Stack trace: $stackTrace', name: 'AuthDatasource');
      rethrow;
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

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Store {

  final FlutterSecureStorage _secureStorage;
  Store(this._secureStorage);



  final  String _tokenKey = 'token';
  final String _refreshTokenKey = 'refreshToken';


  Future<void> setToken(String token) async {
    await _secureStorage.write(key: _tokenKey,value:  token,);
  }

  Future<String?> getToken() async {
    return _secureStorage.read(key: _tokenKey);
  }

  Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey,value:  token);
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> clear() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }
  Future<bool> isTokenAvailable() async {
    String? token = await _secureStorage.read( key: _tokenKey);
    return Future.value((token != null));
  }
}
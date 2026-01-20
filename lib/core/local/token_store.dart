import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Store {

  final FlutterSecureStorage _secureStorage;
  Store(this._secureStorage);



  final  String _tokenKey = 'token';
  final String _refreshTokenKey = 'refreshToken';
  final String _isResponsibleKey = 'isResponsible';

  final String _selectedCrmIdKey = 'selectedCrmId';

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

  Future<void> setIsResponsible(bool isResponsible) async {
    await _secureStorage.write(key: _isResponsibleKey, value: isResponsible.toString());
  }

  Future<bool?> getIsResponsible() async {
    final value = await _secureStorage.read(key: _isResponsibleKey);
    if (value == null) return null;
    return value == 'true';
  }

  Future<void> clear() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _isResponsibleKey);
  }
  Future<void> clearSelectedCrm() async {
    await _secureStorage.delete(key: _selectedCrmIdKey);
  }

  Future<bool> isTokenAvailable() async {
    String? token = await _secureStorage.read( key: _tokenKey);
    return Future.value((token != null));
  }

  Future<void> setSelectedCrmId(int id) async {
    await _secureStorage.write(key: _selectedCrmIdKey, value: id.toString());
  }

  Future<int?> getSelectedCrmId() async {
    final value = await _secureStorage.read(key: _selectedCrmIdKey);
    if (value == null || value.isEmpty) return null;
    return int.tryParse(value);
  }
}
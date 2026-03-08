import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/api/api_client.dart';
import 'package:fitness_tracker/core/api/api_endpoints.dart';
import 'package:fitness_tracker/features/auth/data/datasources/auth_datasource.dart';
import 'package:fitness_tracker/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authRemoteDatasourceProvider = Provider<IAuthDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRemoteDataSource(apiClient: apiClient);
});

class AuthRemoteDataSource implements IAuthDataSource {
  final ApiClient _apiClient;
  final _storage = const FlutterSecureStorage();

  AuthRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<AuthHiveModel> register(AuthHiveModel user) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'fullName': user.fullName,
          'email': user.email,
          'username': user.username,
          'password': user.password,
          'confirmPassword': user.password,
        },
      );

      final data = response.data['data'];
      await _storage.write(key: 'auth_token', value: data['accessToken']);

      return AuthHiveModel(
        authId: data['user']['id'],
        fullName: user.fullName,
        email: user.email,
        username: user.username,
        password: '',
      );
    } catch (e) {
      if (e is DioException && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Registration failed');
      }
      throw Exception(e.toString());
    }
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data['data'];
      await _storage.write(key: 'auth_token', value: data['accessToken']);

      return AuthHiveModel(
        authId: data['user']['id'],
        fullName: data['user']['fullName'] ?? '',
        email: data['user']['email'] ?? email,
        username: data['user']['username'] ?? '',
        password: '',
      );
    } catch (e) {
      if (e is DioException && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Login failed');
      }
      throw Exception(e.toString());
    }
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) return null;

      final response = await _apiClient.get(ApiEndpoints.myProfile);
      final data = response.data['data'];

      return AuthHiveModel(
        authId: data['id'],
        fullName: data['fullName'] ?? '',
        email: data['email'] ?? '',
        username: data['username'] ?? '',
        profilePicture: data['imageUrl'],
        password: '',
      );
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        await logout();
      }
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    await _storage.delete(key: 'auth_token');
    return true;
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) async => null;
  @override
  Future<AuthHiveModel?> getUserByEmail(String email) async => null;
  @override
  Future<bool> updateUser(AuthHiveModel user) async => false;
  @override
  Future<bool> deleteUser(String authId) async => false;
}

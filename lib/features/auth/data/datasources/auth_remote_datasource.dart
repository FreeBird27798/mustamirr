import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
  });
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.sharedPreferences,
  });

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );
    final user = UserModel.fromJson(response.data['user']);
    await sharedPreferences.setString('auth_token', user.token);
    await sharedPreferences.setString('user_role', user.role);
    return user;
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await apiClient.dio.post(
      '/register',
      data: {'name': name, 'email': email, 'password': password, 'role': role},
    );
    final user = UserModel.fromJson(response.data['user']);
    await sharedPreferences.setString('auth_token', user.token);
    await sharedPreferences.setString('user_role', user.role);
    return user;
  }

  @override
  Future<void> logout() async {
    await apiClient.dio.post('/logout');
    await sharedPreferences.remove('auth_token');
    await sharedPreferences.remove('user_role');
  }
}

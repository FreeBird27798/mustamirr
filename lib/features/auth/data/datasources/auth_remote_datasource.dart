import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/errors/exceptions.dart';
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

  // ⚠️ MOCK auth — replace with real Dio calls in Phase 6.
  // Fake accounts for testing (all use password: 123456).
  static const _mockPassword = '123456';
  static const _mockUsers = {
    'student@test.com': {'name': 'سعدي حرب', 'role': 'student'},
    'teacher@test.com': {'name': 'يوسف احمد', 'role': 'teacher'},
    'admin@test.com': {'name': 'مدير النظام', 'role': 'admin'},
  };

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final match = _mockUsers[email.trim().toLowerCase()];
    if (match == null || password.trim() != _mockPassword) {
      throw const ServerException('البريد الإلكتروني أو كلمة المرور غير صحيحة');
    }
    final user = UserModel(
      id: email.hashCode.toString(),
      name: match['name']!,
      email: email.trim().toLowerCase(),
      role: match['role']!,
      token: 'mock_token_${match['role']}',
    );
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
    await Future.delayed(const Duration(milliseconds: 600));
    final user = UserModel(
      id: email.hashCode.toString(),
      name: name,
      email: email.trim().toLowerCase(),
      role: role,
      token: 'mock_token_$role',
    );
    await sharedPreferences.setString('auth_token', user.token);
    await sharedPreferences.setString('user_role', user.role);
    return user;
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.dio.post('/logout');
    } catch (_) {
      // Best-effort: server logout failing shouldn't block local logout
    }
    await sharedPreferences.remove('auth_token');
    await sharedPreferences.remove('user_role');
  }
}

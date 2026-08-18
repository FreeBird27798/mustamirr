import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<void> register({
    required String name,
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
    required String role,
  });
  Future<void> verifyEmail({required String email, required String otp});
  Future<void> resendVerification({required String email});
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
    // `email` here is really the "login" field — the backend accepts either
    // an email address or a username.
    final response = await apiClient.dio.post(
      '/auth/login',
      data: {
        'login': email.trim(),
        'password': password,
        'remember': true,
      },
    );

    final data = (response.data['data'] as Map).cast<String, dynamic>();
    final user = UserModel.fromAuthData(data);
    await _persistSession(user);
    return user;
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    // Creates the account (unverified) and triggers an OTP email. No session is
    // returned — the user verifies via [verifyEmail] then logs in.
    await apiClient.dio.post(
      '/auth/register',
      data: {
        'name': name.trim(),
        'email': email.trim(),
        'username': username.trim(),
        'password': password,
        'password_confirmation': passwordConfirmation,
        'role': role,
      },
    );
  }

  @override
  Future<void> verifyEmail({
    required String email,
    required String otp,
  }) async {
    await apiClient.dio.post(
      '/auth/verify-email',
      data: {'email': email.trim(), 'otp': otp.trim()},
    );
  }

  @override
  Future<void> resendVerification({required String email}) async {
    await apiClient.dio.post(
      '/auth/resend-verification',
      data: {'email': email.trim()},
    );
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.dio.post('/auth/logout');
    } catch (_) {
      // Best-effort: server logout failing shouldn't block local logout.
    }
    await sharedPreferences.remove('auth_token');
    await sharedPreferences.remove('user_role');
  }

  Future<void> _persistSession(UserModel user) async {
    await sharedPreferences.setString('auth_token', user.token);
    await sharedPreferences.setString('user_role', user.role);
  }
}

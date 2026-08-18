import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// NOTE: placeholder for the public repo. The real backend URL is injected
// locally and kept out of git via `git update-index --skip-worktree` on this
// file. If you clone fresh, set your own backend URL here (and re-apply
// skip-worktree so it isn't committed).
const String baseUrl = 'https://api.example.com/api';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}

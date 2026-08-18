import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user_entity.dart';

/// Holds the currently signed-in user for the whole app so screens can show
/// the real name/role instead of hard-coded placeholders. The user is cached
/// in SharedPreferences so it survives app restarts (loaded in the
/// constructor, since the backend session is restored from the saved token).
class SessionCubit extends Cubit<UserEntity?> {
  final SharedPreferences prefs;

  static const _storageKey = 'auth_user';

  SessionCubit(this.prefs) : super(null) {
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        emit(UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      } catch (_) {
        // Corrupt cache — ignore and start with no user.
      }
    }
  }

  /// Called after a successful login to make the user available app-wide.
  Future<void> setUser(UserEntity user) async {
    final model = user is UserModel
        ? user
        : UserModel(
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role,
            token: user.token,
          );
    await prefs.setString(_storageKey, jsonEncode(model.toJson()));
    emit(user);
  }

  /// Called on logout to clear the cached user.
  Future<void> clear() async {
    await prefs.remove(_storageKey);
    emit(null);
  }
}

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.token,
  });

  /// Builds a [UserModel] from the `data` object of a successful auth
  /// response, e.g. `/auth/login` returns:
  /// `{ "data": { "user": { id, name, email, role, ... }, "token": "..." } }`.
  factory UserModel.fromAuthData(Map<String, dynamic> data) {
    final user = (data['user'] as Map).cast<String, dynamic>();
    return UserModel(
      id: user['id'].toString(),
      name: (user['name'] ?? '') as String,
      email: (user['email'] ?? '') as String,
      role: (user['role'] ?? '') as String,
      token: (data['token'] ?? '') as String,
    );
  }
}

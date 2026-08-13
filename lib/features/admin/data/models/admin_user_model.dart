import '../../domain/entities/admin_user_entity.dart';

class AdminUserModel extends AdminUserEntity {
  const AdminUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.isActive,
    required super.affiliation,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: json['is_active'] as bool,
      affiliation: json['affiliation'] as String,
    );
  }

  AdminUserModel copyWith({bool? isActive}) {
    return AdminUserModel(
      id: id,
      name: name,
      email: email,
      role: role,
      isActive: isActive ?? this.isActive,
      affiliation: affiliation,
    );
  }
}

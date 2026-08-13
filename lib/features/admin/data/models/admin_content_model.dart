import '../../domain/entities/admin_content_entity.dart';

class AdminContentModel extends AdminContentEntity {
  const AdminContentModel({
    required super.id,
    required super.title,
    required super.subject,
    required super.teacherName,
    required super.fileType,
    required super.downloadsCount,
  });

  factory AdminContentModel.fromJson(Map<String, dynamic> json) {
    return AdminContentModel(
      id: json['id'] as int,
      title: json['title'] as String,
      subject: json['subject'] as String,
      teacherName: json['teacher_name'] as String,
      fileType: json['file_type'] as String,
      downloadsCount: json['downloads_count'] as int,
    );
  }
}

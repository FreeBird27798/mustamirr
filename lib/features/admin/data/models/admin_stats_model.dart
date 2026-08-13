import '../../domain/entities/admin_stats_entity.dart';

class AdminStatsModel extends AdminStatsEntity {
  const AdminStatsModel({
    required super.studentsCount,
    required super.subjectsCount,
    required super.teachersCount,
    required super.filesCount,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      studentsCount: json['students_count'] as int,
      subjectsCount: json['subjects_count'] as int,
      teachersCount: json['teachers_count'] as int,
      filesCount: json['files_count'] as int,
    );
  }
}

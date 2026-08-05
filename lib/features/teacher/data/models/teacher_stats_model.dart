import '../../domain/entities/teacher_stats_entity.dart';

class TeacherStatsModel extends TeacherStatsEntity {
  const TeacherStatsModel({
    required super.studentsCount,
    required super.lessonsCount,
    required super.coursesCount,
    required super.downloadsCount,
  });

  factory TeacherStatsModel.fromJson(Map<String, dynamic> json) {
    return TeacherStatsModel(
      studentsCount: json['students_count'] as int,
      lessonsCount: json['lessons_count'] as int,
      coursesCount: json['courses_count'] as int,
      downloadsCount: json['downloads_count'] as int,
    );
  }
}

import '../../domain/entities/teacher_stats_entity.dart';

class TeacherStatsModel extends TeacherStatsEntity {
  const TeacherStatsModel({
    required super.studentsCount,
    required super.lessonsCount,
    required super.coursesCount,
    required super.downloadsCount,
  });

  /// From `/teacher/dashboard` → `data.stats`:
  /// `{ tracks_count, lessons_count, students_count, downloads_count }`.
  factory TeacherStatsModel.fromJson(Map<String, dynamic> json) {
    int intOf(List<String> keys) {
      for (final k in keys) {
        final v = json[k];
        if (v is num) return v.toInt();
      }
      return 0;
    }

    return TeacherStatsModel(
      studentsCount: intOf(['students_count']),
      lessonsCount: intOf(['lessons_count']),
      coursesCount: intOf(['tracks_count', 'courses_count']),
      downloadsCount: intOf(['downloads_count']),
    );
  }
}

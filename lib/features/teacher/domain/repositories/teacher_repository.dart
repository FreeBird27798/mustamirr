import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/teacher_lesson_entity.dart';
import '../entities/teacher_stats_entity.dart';
import '../entities/teacher_student_entity.dart';

abstract class TeacherRepository {
  Future<Either<Failure, TeacherStatsEntity>> getDashboardStats();
  Future<Either<Failure, List<TeacherLessonEntity>>> getMyLessons();
  Future<Either<Failure, List<TeacherStudentEntity>>> getMyStudents();
  Future<Either<Failure, Unit>> addLesson(TeacherLessonEntity lesson);
  Future<Either<Failure, Unit>> updateLesson(TeacherLessonEntity lesson);
  Future<Either<Failure, Unit>> deleteLesson(int lessonId);
}

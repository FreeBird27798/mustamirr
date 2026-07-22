import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/lesson_entity.dart';
import '../entities/notification_entity.dart';
import '../entities/subject_entity.dart';

abstract class StudentRepository {
  Future<Either<Failure, List<SubjectEntity>>> getSubjects();
  Future<Either<Failure, List<LessonEntity>>> getRecentLessons();
  Future<Either<Failure, List<LessonEntity>>> getLessons(int subjectId);
  Future<Either<Failure, List<LessonEntity>>> getFavorites();
  Future<Either<Failure, List<LessonEntity>>> getDownloads();
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, Unit>> toggleFavorite(int lessonId);
  Future<Either<Failure, Unit>> downloadLesson(int lessonId);
  Future<Either<Failure, Unit>> deleteDownload(int lessonId);
}

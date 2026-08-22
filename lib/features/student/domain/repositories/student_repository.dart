import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/affiliation.dart';
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
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, Unit>> markAllNotificationsRead();
  Future<Either<Failure, Unit>> toggleFavorite(int lessonId);
  Future<Either<Failure, Unit>> downloadLesson(int lessonId);
  Future<Either<Failure, Unit>> deleteDownload(int lessonId);

  // Affiliation (institution selection)
  Future<Either<Failure, List<InstitutionTypeEntity>>> getInstitutionTypes();
  Future<Either<Failure, List<InstitutionEntity>>> getInstitutions(String type);
  Future<Either<Failure, List<AcademicLevelEntity>>> getLevels(
    int institutionId,
  );
  Future<Either<Failure, List<SpecializationEntity>>> getSpecializations(
    int levelId,
  );
  Future<Either<Failure, AffiliationStatusEntity?>> getAffiliationStatus();
  Future<Either<Failure, Unit>> submitAffiliation({
    required String institutionType,
    required int institutionId,
    required int academicLevelId,
    required int specializationId,
  });
}

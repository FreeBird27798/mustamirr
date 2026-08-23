import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../student/domain/repositories/affiliation_repository.dart';
import '../../../student/domain/repositories/search_repository.dart';
import '../entities/teacher_affiliation.dart';
import '../entities/teacher_lesson_entity.dart';
import '../entities/teacher_stats_entity.dart';
import '../entities/teacher_student_entity.dart';

abstract class TeacherRepository
    implements AffiliationRepository, SearchRepository {
  Future<Either<Failure, TeacherStatsEntity>> getDashboardStats();
  Future<Either<Failure, List<TeacherLessonEntity>>> getMyLessons();
  Future<Either<Failure, List<TeacherStudentEntity>>> getMyStudents();
  Future<Either<Failure, Unit>> addLesson(TeacherLessonEntity lesson);
  Future<Either<Failure, Unit>> updateLesson(TeacherLessonEntity lesson);
  Future<Either<Failure, Unit>> deleteLesson(int lessonId);

  // The institution-type/institution/level/specialization cascade is inherited
  // from AffiliationRepository. A teacher affiliates differently from a student
  // (many levels + many subjects), so the status/submit below are its own.
  Future<Either<Failure, List<SubjectOptionEntity>>> getSubjectOptions();
  Future<Either<Failure, TeacherAffiliationStatusEntity?>>
  getTeacherAffiliationStatus();
  Future<Either<Failure, Unit>> submitTeacherAffiliation({
    required String institutionType,
    required int institutionId,
    required List<int> academicLevelIds,
    required List<int> subjectIds,
    required int specializationId,
  });
}

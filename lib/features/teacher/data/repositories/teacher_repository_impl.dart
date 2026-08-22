import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../student/domain/entities/affiliation.dart';
import '../../domain/entities/teacher_lesson_entity.dart';
import '../../domain/entities/teacher_stats_entity.dart';
import '../../domain/entities/teacher_student_entity.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../datasources/teacher_remote_datasource.dart';
import '../models/lesson_content_model.dart';
import '../models/teacher_lesson_model.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherRemoteDataSource remoteDataSource;

  TeacherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TeacherStatsEntity>> getDashboardStats() async {
    try {
      final stats = await remoteDataSource.getDashboardStats();
      return Right(stats);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<TeacherLessonEntity>>> getMyLessons() async {
    try {
      final lessons = await remoteDataSource.getMyLessons();
      return Right(lessons);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<TeacherStudentEntity>>> getMyStudents() async {
    try {
      final students = await remoteDataSource.getMyStudents();
      return Right(students);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> addLesson(TeacherLessonEntity lesson) async {
    try {
      await remoteDataSource.addLesson(_toModel(lesson));
      return const Right(unit);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLesson(TeacherLessonEntity lesson) async {
    try {
      await remoteDataSource.updateLesson(_toModel(lesson));
      return const Right(unit);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLesson(int lessonId) async {
    try {
      await remoteDataSource.deleteLesson(lessonId);
      return const Right(unit);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  // ===== Affiliation =====

  @override
  Future<Either<Failure, List<InstitutionTypeEntity>>>
  getInstitutionTypes() async {
    try {
      return Right(await remoteDataSource.getInstitutionTypes());
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<InstitutionEntity>>> getInstitutions(
    String type,
  ) async {
    try {
      return Right(await remoteDataSource.getInstitutions(type));
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AcademicLevelEntity>>> getLevels(
    int institutionId,
  ) async {
    try {
      return Right(await remoteDataSource.getLevels(institutionId));
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SpecializationEntity>>> getSpecializations(
    int levelId,
  ) async {
    try {
      return Right(await remoteDataSource.getSpecializations(levelId));
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AffiliationStatusEntity?>>
  getAffiliationStatus() async {
    try {
      return Right(await remoteDataSource.getAffiliationStatus());
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitAffiliation({
    required String institutionType,
    required int institutionId,
    required int academicLevelId,
    required int specializationId,
  }) async {
    try {
      await remoteDataSource.submitAffiliation(
        institutionType: institutionType,
        institutionId: institutionId,
        academicLevelId: academicLevelId,
        specializationId: specializationId,
      );
      return const Right(unit);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  TeacherLessonModel _toModel(TeacherLessonEntity lesson) {
    return TeacherLessonModel(
      id: lesson.id,
      title: lesson.title,
      description: lesson.description,
      subject: lesson.subject,
      grade: lesson.grade,
      fileType: lesson.fileType,
      fileSizeMb: lesson.fileSizeMb,
      contents: lesson.contents
          .map((e) => LessonContentModel(title: e.title, body: e.body))
          .toList(),
    );
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_remote_datasource.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SubjectEntity>>> getSubjects() async {
    try {
      final subjects = await remoteDataSource.getSubjects();
      return Right(subjects);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<LessonEntity>>> getRecentLessons() async {
    try {
      final recentLessons = await remoteDataSource.getRecentLessons();
      return Right(recentLessons);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<LessonEntity>>> getLessons(int subjectId) async {
    try {
      final lessons = await remoteDataSource.getLessons(subjectId);
      return Right(lessons);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<LessonEntity>>> getFavorites() async {
    try {
      final favorites = await remoteDataSource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<LessonEntity>>> getDownloads() async {
    try {
      final downloads = await remoteDataSource.getDownloads();
      return Right(downloads);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await remoteDataSource.getUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllNotificationsRead() async {
    try {
      await remoteDataSource.markAllNotificationsRead();
      return const Right(unit);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(int lessonId) async {
    try {
      await remoteDataSource.toggleFavorite(lessonId);
      return const Right(unit);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> downloadLesson(int lessonId) async {
    try {
      await remoteDataSource.downloadLesson(lessonId);
      return const Right(unit);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDownload(int lessonId) async {
    try {
      await remoteDataSource.deleteDownload(lessonId);
      return const Right(unit);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }
}

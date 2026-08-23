import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lesson_entity.dart';

/// Shared "port" for content search. Both [StudentRepository] and [TeacherRepository]
/// implement it, so one search screen/cubit serves both roles
/// (only the `/student` vs `/teacher` endpoint prefix differs). Results are
/// lessons; `getRecentSearches` returns the recent query terms.
abstract class SearchRepository {
  Future<Either<Failure, List<LessonEntity>>> search(String query);
  Future<Either<Failure, List<String>>> getRecentSearches();
}

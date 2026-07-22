import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lesson_entity.dart';
import '../repositories/student_repository.dart';

class GetLessonsUseCase implements UseCase<List<LessonEntity>, int> {
  final StudentRepository repository;

  GetLessonsUseCase(this.repository);

  @override
  Future<Either<Failure, List<LessonEntity>>> call(int subjectId) {
    return repository.getLessons(subjectId);
  }
}

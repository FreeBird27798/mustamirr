import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/teacher_lesson_entity.dart';
import '../repositories/teacher_repository.dart';

class GetMyLessonsUseCase
    implements UseCase<List<TeacherLessonEntity>, NoParams> {
  final TeacherRepository repository;
  GetMyLessonsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TeacherLessonEntity>>> call(NoParams params) {
    return repository.getMyLessons();
  }
}

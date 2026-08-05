import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/teacher_lesson_entity.dart';
import '../repositories/teacher_repository.dart';

class UpdateLessonUseCase implements UseCase<Unit, TeacherLessonEntity> {
  final TeacherRepository repository;
  UpdateLessonUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(TeacherLessonEntity lesson) {
    return repository.updateLesson(lesson);
  }
}

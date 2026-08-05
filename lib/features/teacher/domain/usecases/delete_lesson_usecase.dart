import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/teacher_repository.dart';

class DeleteLessonUseCase implements UseCase<Unit, int> {
  final TeacherRepository repository;
  DeleteLessonUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int lessonId) {
    return repository.deleteLesson(lessonId);
  }
}

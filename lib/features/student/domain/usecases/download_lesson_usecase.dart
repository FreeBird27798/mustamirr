import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/student_repository.dart';

class DownloadLessonUseCase implements UseCase<Unit, int> {
  final StudentRepository repository;
  DownloadLessonUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(int lessonId) {
    return repository.downloadLesson(lessonId);
  }
}

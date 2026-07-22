import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lesson_entity.dart';
import '../repositories/student_repository.dart';

class GetDownloadsUseCase implements UseCase<List<LessonEntity>, NoParams> {
  final StudentRepository repository;
  GetDownloadsUseCase(this.repository);

  @override
  Future<Either<Failure, List<LessonEntity>>> call(NoParams params) {
    return repository.getDownloads();
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lesson_entity.dart';
import '../repositories/student_repository.dart';

class GetFavoritesUseCase implements UseCase<List<LessonEntity>, NoParams> {
  final StudentRepository repository;
  GetFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<LessonEntity>>> call(NoParams params) {
    return repository.getFavorites();
  }
}

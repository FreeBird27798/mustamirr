import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/student_repository.dart';

class ToggleFavoriteUseCase implements UseCase<Unit, int> {
  final StudentRepository repository;
  ToggleFavoriteUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(int lessonId) {
    return repository.toggleFavorite(lessonId);
  }
}

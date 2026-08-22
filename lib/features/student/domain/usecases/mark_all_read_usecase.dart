import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/student_repository.dart';

class MarkAllReadUseCase implements UseCase<Unit, NoParams> {
  final StudentRepository repository;
  MarkAllReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.markAllNotificationsRead();
  }
}

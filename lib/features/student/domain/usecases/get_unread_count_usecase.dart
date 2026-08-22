import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/student_repository.dart';

class GetUnreadCountUseCase implements UseCase<int, NoParams> {
  final StudentRepository repository;
  GetUnreadCountUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return repository.getUnreadCount();
  }
}

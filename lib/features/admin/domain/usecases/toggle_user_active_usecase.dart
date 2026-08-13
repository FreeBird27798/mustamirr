import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class ToggleUserActiveUseCase implements UseCase<Unit, int> {
  final AdminRepository repository;
  ToggleUserActiveUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int userId) {
    return repository.toggleUserActive(userId);
  }
}

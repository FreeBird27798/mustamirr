import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class DeleteUserUseCase implements UseCase<Unit, int> {
  final AdminRepository repository;
  DeleteUserUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int userId) {
    return repository.deleteUser(userId);
  }
}

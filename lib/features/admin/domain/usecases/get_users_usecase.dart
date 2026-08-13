import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_repository.dart';

class GetUsersUseCase implements UseCase<List<AdminUserEntity>, NoParams> {
  final AdminRepository repository;
  GetUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<AdminUserEntity>>> call(NoParams params) {
    return repository.getUsers();
  }
}

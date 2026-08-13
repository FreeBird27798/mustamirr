import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class DeleteInstitutionUseCase implements UseCase<Unit, int> {
  final AdminRepository repository;
  DeleteInstitutionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int institutionId) {
    return repository.deleteInstitution(institutionId);
  }
}

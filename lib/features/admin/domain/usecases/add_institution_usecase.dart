import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/institution_entity.dart';
import '../repositories/admin_repository.dart';

class AddInstitutionUseCase implements UseCase<Unit, InstitutionEntity> {
  final AdminRepository repository;
  AddInstitutionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(InstitutionEntity institution) {
    return repository.addInstitution(institution);
  }
}

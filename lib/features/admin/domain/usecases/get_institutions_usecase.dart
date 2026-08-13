import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/institution_entity.dart';
import '../repositories/admin_repository.dart';

/// Params: the institution type to load (university/school/specialization/grade).
class GetInstitutionsUseCase
    implements UseCase<List<InstitutionEntity>, String> {
  final AdminRepository repository;
  GetInstitutionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<InstitutionEntity>>> call(String type) {
    return repository.getInstitutions(type);
  }
}

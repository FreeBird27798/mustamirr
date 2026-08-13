import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_subject_entity.dart';
import '../repositories/admin_repository.dart';

class AddSubjectUseCase implements UseCase<Unit, AdminSubjectEntity> {
  final AdminRepository repository;
  AddSubjectUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AdminSubjectEntity subject) {
    return repository.addSubject(subject);
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_subject_entity.dart';
import '../repositories/admin_repository.dart';

class GetAdminSubjectsUseCase
    implements UseCase<List<AdminSubjectEntity>, NoParams> {
  final AdminRepository repository;
  GetAdminSubjectsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AdminSubjectEntity>>> call(NoParams params) {
    return repository.getSubjects();
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class DeleteSubjectUseCase implements UseCase<Unit, int> {
  final AdminRepository repository;
  DeleteSubjectUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int subjectId) {
    return repository.deleteSubject(subjectId);
  }
}

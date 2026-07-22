import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subject_entity.dart';
import '../repositories/student_repository.dart';

class GetSubjectsUseCase implements UseCase<List<SubjectEntity>, NoParams> {
  final StudentRepository repository;
  GetSubjectsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SubjectEntity>>> call(NoParams params) {
    return repository.getSubjects();
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/enrollment_request_entity.dart';
import '../repositories/admin_repository.dart';

class GetEnrollmentRequestsUseCase
    implements UseCase<List<EnrollmentRequestEntity>, NoParams> {
  final AdminRepository repository;
  GetEnrollmentRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<EnrollmentRequestEntity>>> call(NoParams params) {
    return repository.getEnrollmentRequests();
  }
}

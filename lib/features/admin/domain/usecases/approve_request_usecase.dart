import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class ApproveRequestUseCase implements UseCase<Unit, int> {
  final AdminRepository repository;
  ApproveRequestUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int requestId) {
    return repository.approveRequest(requestId);
  }
}

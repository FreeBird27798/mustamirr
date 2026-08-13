import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class RejectRequestUseCase implements UseCase<Unit, int> {
  final AdminRepository repository;
  RejectRequestUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int requestId) {
    return repository.rejectRequest(requestId);
  }
}

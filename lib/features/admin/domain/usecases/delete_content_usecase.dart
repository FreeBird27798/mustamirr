import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class DeleteContentUseCase implements UseCase<Unit, int> {
  final AdminRepository repository;
  DeleteContentUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int contentId) {
    return repository.deleteContent(contentId);
  }
}

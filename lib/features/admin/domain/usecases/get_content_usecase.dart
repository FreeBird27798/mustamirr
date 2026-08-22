import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_content_entity.dart';
import '../repositories/admin_repository.dart';

class GetContentUseCase implements UseCase<List<AdminContentEntity>, NoParams> {
  final AdminRepository repository;
  GetContentUseCase(this.repository);

  @override
  Future<Either<Failure, List<AdminContentEntity>>> call(NoParams params) {
    return repository.getContent();
  }
}

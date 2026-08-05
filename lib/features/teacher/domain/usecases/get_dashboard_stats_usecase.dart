import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/teacher_stats_entity.dart';
import '../repositories/teacher_repository.dart';

class GetDashboardStatsUseCase
    implements UseCase<TeacherStatsEntity, NoParams> {
  final TeacherRepository repository;
  GetDashboardStatsUseCase(this.repository);

  @override
  Future<Either<Failure, TeacherStatsEntity>> call(NoParams params) {
    return repository.getDashboardStats();
  }
}

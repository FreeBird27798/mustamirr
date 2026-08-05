import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/teacher_student_entity.dart';
import '../repositories/teacher_repository.dart';

class GetMyStudentsUseCase
    implements UseCase<List<TeacherStudentEntity>, NoParams> {
  final TeacherRepository repository;
  GetMyStudentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TeacherStudentEntity>>> call(NoParams params) {
    return repository.getMyStudents();
  }
}

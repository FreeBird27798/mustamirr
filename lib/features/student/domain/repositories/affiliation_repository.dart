import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/affiliation.dart';

/// Shared "port" for the affiliation (institution selection) flow. Both
/// [StudentRepository] and the teacher repository implement it, so the same
/// affiliation screen/cubit works for either role (only the `/student` vs
/// `/teacher` endpoint prefix differs).
abstract class AffiliationRepository {
  Future<Either<Failure, List<InstitutionTypeEntity>>> getInstitutionTypes();
  Future<Either<Failure, List<InstitutionEntity>>> getInstitutions(String type);
  Future<Either<Failure, List<AcademicLevelEntity>>> getLevels(
    int institutionId,
  );
  Future<Either<Failure, List<SpecializationEntity>>> getSpecializations(
    int levelId,
  );
  Future<Either<Failure, AffiliationStatusEntity?>> getAffiliationStatus();
  Future<Either<Failure, Unit>> submitAffiliation({
    required String institutionType,
    required int institutionId,
    required int academicLevelId,
    required int specializationId,
  });
}

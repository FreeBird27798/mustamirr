import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/admin_content_entity.dart';
import '../entities/admin_stats_entity.dart';
import '../entities/admin_subject_entity.dart';
import '../entities/admin_user_entity.dart';
import '../entities/enrollment_request_entity.dart';
import '../entities/institution_entity.dart';

abstract class AdminRepository {
  Future<Either<Failure, AdminStatsEntity>> getStats();
  Future<Either<Failure, List<AdminUserEntity>>> getUsers();
  Future<Either<Failure, Unit>> toggleUserActive(int userId);
  Future<Either<Failure, Unit>> deleteUser(int userId);

  Future<Either<Failure, List<EnrollmentRequestEntity>>>
  getEnrollmentRequests();
  Future<Either<Failure, Unit>> approveRequest(int requestId);
  Future<Either<Failure, Unit>> rejectRequest(int requestId);

  Future<Either<Failure, List<InstitutionEntity>>> getInstitutions(String type);
  Future<Either<Failure, Unit>> addInstitution(InstitutionEntity institution);
  Future<Either<Failure, Unit>> deleteInstitution(int institutionId);

  Future<Either<Failure, List<AdminSubjectEntity>>> getSubjects();
  Future<Either<Failure, Unit>> addSubject(AdminSubjectEntity subject);
  Future<Either<Failure, Unit>> deleteSubject(int subjectId);

  Future<Either<Failure, List<AdminContentEntity>>> getContent();
  Future<Either<Failure, Unit>> deleteContent(int contentId);
}

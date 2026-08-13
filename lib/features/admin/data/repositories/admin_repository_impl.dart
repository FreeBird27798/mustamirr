import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/admin_content_entity.dart';
import '../../domain/entities/admin_stats_entity.dart';
import '../../domain/entities/admin_subject_entity.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../../domain/entities/enrollment_request_entity.dart';
import '../../domain/entities/institution_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';
import '../models/admin_subject_model.dart';
import '../models/institution_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AdminStatsEntity>> getStats() async {
    try {
      final stats = await remoteDataSource.getStats();
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdminUserEntity>>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleUserActive(int userId) async {
    try {
      await remoteDataSource.toggleUserActive(userId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser(int userId) async {
    try {
      await remoteDataSource.deleteUser(userId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EnrollmentRequestEntity>>>
  getEnrollmentRequests() async {
    try {
      final requests = await remoteDataSource.getEnrollmentRequests();
      return Right(requests);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> approveRequest(int requestId) async {
    try {
      await remoteDataSource.approveRequest(requestId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> rejectRequest(int requestId) async {
    try {
      await remoteDataSource.rejectRequest(requestId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InstitutionEntity>>> getInstitutions(
    String type,
  ) async {
    try {
      return Right(await remoteDataSource.getInstitutions(type));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addInstitution(
    InstitutionEntity institution,
  ) async {
    try {
      await remoteDataSource.addInstitution(
        InstitutionModel(
          id: institution.id,
          type: institution.type,
          name: institution.name,
          subtitle: institution.subtitle,
        ),
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteInstitution(int institutionId) async {
    try {
      await remoteDataSource.deleteInstitution(institutionId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdminSubjectEntity>>> getSubjects() async {
    try {
      return Right(await remoteDataSource.getSubjects());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addSubject(AdminSubjectEntity subject) async {
    try {
      await remoteDataSource.addSubject(
        AdminSubjectModel(
          id: subject.id,
          name: subject.name,
          grade: subject.grade,
          lessonsCount: subject.lessonsCount,
        ),
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSubject(int subjectId) async {
    try {
      await remoteDataSource.deleteSubject(subjectId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdminContentEntity>>> getContent() async {
    try {
      return Right(await remoteDataSource.getContent());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteContent(int contentId) async {
    try {
      await remoteDataSource.deleteContent(contentId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

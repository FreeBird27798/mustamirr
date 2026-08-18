import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    try {
      await remoteDataSource.register(
        name: name,
        email: email,
        username: username,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
      );
      return const Right(unit);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      await remoteDataSource.verifyEmail(email: email, otp: otp);
      return const Right(unit);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> resendVerification({
    required String email,
  }) async {
    try {
      await remoteDataSource.resendVerification(email: email);
      return const Right(unit);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }
}

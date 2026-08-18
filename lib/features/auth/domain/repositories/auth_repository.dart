import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Creates a student/teacher account. The account starts unverified and the
  /// backend emails an OTP, so this returns [Unit] (no session) — the user must
  /// verify the email before logging in.
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
    required String role,
  });

  /// Confirms the emailed OTP for [email], activating the account.
  Future<Either<Failure, Unit>> verifyEmail({
    required String email,
    required String otp,
  });

  /// Asks the backend to send a fresh verification OTP to [email].
  Future<Either<Failure, Unit>> resendVerification({required String email});

  Future<Either<Failure, void>> logout();
}

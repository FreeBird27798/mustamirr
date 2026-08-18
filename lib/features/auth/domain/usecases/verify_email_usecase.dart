import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyEmailUseCase implements UseCase<Unit, VerifyEmailParams> {
  final AuthRepository repository;

  VerifyEmailUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(VerifyEmailParams params) {
    return repository.verifyEmail(email: params.email, otp: params.otp);
  }
}

class VerifyEmailParams extends Equatable {
  final String email;
  final String otp;

  const VerifyEmailParams({required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}

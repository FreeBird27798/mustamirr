import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<Unit, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RegisterParams params) {
    return repository.register(
      name: params.name,
      email: params.email,
      username: params.username,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
      role: params.role,
    );
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String username;
  final String password;
  final String passwordConfirmation;
  final String role;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
  });

  @override
  List<Object> get props => [
    name,
    email,
    username,
    password,
    passwordConfirmation,
    role,
  ];
}

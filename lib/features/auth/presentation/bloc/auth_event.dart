import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String username;
  final String password;
  final String passwordConfirmation;
  final String role;

  const RegisterEvent({
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

class VerifyEmailEvent extends AuthEvent {
  final String email;
  final String otp;

  const VerifyEmailEvent({required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}

class ResendVerificationEvent extends AuthEvent {
  final String email;

  const ResendVerificationEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

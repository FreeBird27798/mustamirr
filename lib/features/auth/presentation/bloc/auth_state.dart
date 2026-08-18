import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

/// Account created but not yet verified — the backend emailed an OTP to
/// [email]. The UI should move to the verification screen.
class RegistrationSuccess extends AuthState {
  final String email;

  const RegistrationSuccess(this.email);

  @override
  List<Object> get props => [email];
}

/// The emailed OTP was accepted — the account is active. The UI should send
/// the user to the login screen.
class EmailVerified extends AuthState {
  const EmailVerified();
}

/// A fresh verification OTP was sent (used to confirm a "resend" tap).
class VerificationResent extends AuthState {
  const VerificationResent();
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class LogoutSuccess extends AuthState {
  const LogoutSuccess();
}

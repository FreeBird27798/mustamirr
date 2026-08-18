import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/resend_verification_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final ResendVerificationUseCase resendVerificationUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyEmailUseCase,
    required this.resendVerificationUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<ResendVerificationEvent>(_onResendVerification);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await registerUseCase(
      RegisterParams(
        name: event.name,
        email: event.email,
        username: event.username,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        role: event.role,
      ),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(RegistrationSuccess(event.email)),
    );
  }

  Future<void> _onVerifyEmail(
    VerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await verifyEmailUseCase(
      VerifyEmailParams(email: event.email, otp: event.otp),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const EmailVerified()),
    );
  }

  Future<void> _onResendVerification(
    ResendVerificationEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await resendVerificationUseCase(
      ResendVerificationParams(email: event.email),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const VerificationResent()),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const LogoutSuccess()),
    );
  }
}

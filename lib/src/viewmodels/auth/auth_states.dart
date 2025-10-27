part of 'auth_view_model.dart';

@immutable
sealed class AuthState extends Equatable {}

final class AuthStateInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

///
/// Login States
///

final class LoginLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

final class LoginSuccess extends AuthState {
  final LoginResponse response;

  LoginSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class LoginFailure extends AuthState {
  final String message;

  LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}

///
/// Sign Up States
///

final class SignUpLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

final class SignUpSuccess extends AuthState {
  final User user;

  SignUpSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class SignUpFailure extends AuthState {
  final String message;

  SignUpFailure(this.message);

  @override
  List<Object?> get props => [message];
}

///
/// Send OTP States
///

final class SendOtpLoading extends AuthState {
  @override
  List<Object?> get props => [];
}


final class SendOtpSuccess extends AuthState {
  final SendOtpResponse response;

  SendOtpSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class SendOtpFailure extends AuthState {
  final String message;

  SendOtpFailure(this.message);

  @override
  List<Object?> get props => [message];
}

///
/// Verify OTP States
///

final class VerifyOtpLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

final class VerifyOtpSuccess extends AuthState {
  final VerifyOtpResponse response;

  VerifyOtpSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class VerifyOtpFailure extends AuthState {
  final String message;

  VerifyOtpFailure(this.message);

  @override
  List<Object?> get props => [message];
}

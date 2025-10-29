part of 'auth_view_model.dart';

@immutable
sealed class AuthStates extends Equatable {}

final class AuthStateInitial extends AuthStates {
  @override
  List<Object?> get props => [];
}

///
/// Login States
///

final class LoginLoading extends AuthStates {
  @override
  List<Object?> get props => [];
}

final class LoginSuccess extends AuthStates {
  final LoginResponse response;

  LoginSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class LoginFailure extends AuthStates {
  final String message;

  LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}

///
/// Sign Up States
///

final class SignUpLoading extends AuthStates {
  @override
  List<Object?> get props => [];
}

final class SignUpSuccess extends AuthStates {
  final User user;

  SignUpSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class SignUpFailure extends AuthStates {
  final String message;

  SignUpFailure(this.message);

  @override
  List<Object?> get props => [message];
}

///
/// Send OTP States
///

final class SendOtpLoading extends AuthStates {
  @override
  List<Object?> get props => [];
}


final class SendOtpSuccess extends AuthStates {
  final SendOtpResponse response;

  SendOtpSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class SendOtpFailure extends AuthStates {
  final String message;

  SendOtpFailure(this.message);

  @override
  List<Object?> get props => [message];
}

///
/// Verify OTP States
///

final class VerifyOtpLoading extends AuthStates {
  @override
  List<Object?> get props => [];
}

final class VerifyOtpSuccess extends AuthStates {
  final VerifyOtpResponse response;

  VerifyOtpSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class VerifyOtpFailure extends AuthStates {
  final String message;

  VerifyOtpFailure(this.message);

  @override
  List<Object?> get props => [message];
}

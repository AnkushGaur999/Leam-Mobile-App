part of 'auth_view_model.dart';

sealed class AuthEvent extends Equatable {}

class LoginEvent extends AuthEvent {
  final LoginRequest loginRequestData;

  LoginEvent({required this.loginRequestData});

  @override
  List<Object?> get props => [loginRequestData];
}

class SignUpEvent extends AuthEvent {
  final SignUpRequest signUpRequestData;

  SignUpEvent({required this.signUpRequestData});

  @override
  List<Object?> get props => [signUpRequestData];

}

class SendOtpEvent extends AuthEvent {
  final SendOtpRequest request;

  SendOtpEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class VerifyOtpEvent extends AuthEvent {
  final VerifyOtpRequest request;

  VerifyOtpEvent(this.request);

  @override
  List<Object?> get props => [request];
}

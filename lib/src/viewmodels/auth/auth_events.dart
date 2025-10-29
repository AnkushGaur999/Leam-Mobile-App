part of 'auth_view_model.dart';

sealed class AuthEvents extends Equatable {}

class LoginEvent extends AuthEvents {
  final LoginRequest loginRequestData;

  LoginEvent({required this.loginRequestData});

  @override
  List<Object?> get props => [loginRequestData];
}

class SignUpEvent extends AuthEvents {
  final SignUpRequest signUpRequestData;

  SignUpEvent({required this.signUpRequestData});

  @override
  List<Object?> get props => [signUpRequestData];

}

class SendOtpEvent extends AuthEvents {
  final SendOtpRequest request;

  SendOtpEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class VerifyOtpEvent extends AuthEvents {
  final VerifyOtpRequest request;

  VerifyOtpEvent(this.request);

  @override
  List<Object?> get props => [request];
}

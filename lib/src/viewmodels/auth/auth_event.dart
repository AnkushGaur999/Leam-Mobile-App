part of 'auth_view_model.dart';

sealed class AuthEvent extends Equatable {}

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

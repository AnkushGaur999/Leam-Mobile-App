part of 'auth_view_model.dart';

@immutable
sealed class AuthState extends Equatable {}

final class AuthStateInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

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

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/core/data/local/app_storage.dart';
import 'package:leam/src/models/auth/request/login_request.dart';
import 'package:leam/src/models/auth/request/sign_up_request.dart';
import 'package:leam/src/models/auth/request/verify_otp_request.dart';
import 'package:leam/src/models/auth/response/login_response.dart';
import 'package:leam/src/models/auth/response/verify_otp_response.dart';
import 'package:leam/src/repositories/auth_repository.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/models/auth/request/send_otp_request.dart';
import 'package:leam/src/models/auth/response/send_otp_response.dart';

part 'auth_events.dart';

part 'auth_states.dart';

class AuthViewModel extends Bloc<AuthEvents, AuthStates> {
  final AuthRepository repository;
  final AppStorage appStorage;

  AuthViewModel({required this.repository, required this.appStorage})
    : super(AuthStateInitial()) {
    on<SendOtpEvent>(_sendOtp);
    on<VerifyOtpEvent>(_verifyOtp);
    on<LoginEvent>(_login);
    on<SignUpEvent>(_signUp);
  }

  Future<void> _sendOtp(SendOtpEvent event, Emitter<AuthStates> emit) async {
    emit(SendOtpLoading());

    final response = await repository.sendOtp(requestData: event.request);

    if (response is DataSuccess) {
      appStorage.write(
        key: "user",
        value: response.data!.data!.toJson().toString(),
      );

      emit(SendOtpSuccess(response.data as SendOtpResponse));
    } else {
      emit(SendOtpFailure(response.message!));
    }
  }

  Future<void> _verifyOtp(VerifyOtpEvent event, Emitter<AuthStates> emit) async {
    emit(VerifyOtpLoading());

    final response = await repository.verifyOtp(requestData: event.request);

    if (response is DataSuccess) {
      emit(VerifyOtpSuccess(response.data as VerifyOtpResponse));
    } else {
      emit(VerifyOtpFailure(response.message!));
    }
  }

  Future<void> _login(LoginEvent event, Emitter<AuthStates> emit) async {
    emit(LoginLoading());

    final response = await repository.loginWithEmailAndPassword(
      email: event.loginRequestData.email,
      password: event.loginRequestData.password,
    );

    if (response is DataSuccess) {
      emit(LoginSuccess(response: response.data as LoginResponse));
    } else {
      emit(LoginFailure(response.message!));
    }
  }

  Future<void> _signUp(SignUpEvent event, Emitter<AuthStates> emit) async {
    emit(SignUpLoading());

    final response = await repository.signUp(
      requestData: event.signUpRequestData,
    );

    if (response is DataSuccess) {
      emit(SignUpSuccess(response.data as User));
    } else {
      emit(SignUpFailure(response.message!));
    }
  }
}

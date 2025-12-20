import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:leam/src/core/app_exceptions.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/core/data/remote/dio_client.dart';
import 'package:leam/src/models/auth/request/send_otp_request.dart';
import 'package:leam/src/models/auth/request/sign_up_request.dart';
import 'package:leam/src/models/auth/request/verify_otp_request.dart';
import 'package:leam/src/models/auth/response/login_response.dart';
import 'package:leam/src/models/auth/response/send_otp_response.dart';
import 'package:leam/src/models/auth/response/verify_otp_response.dart';

abstract class AuthRepository {
  Future<DataState<LoginResponse>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<DataState<User>> signUp({required SignUpRequest requestData});

  Future<DataState<SendOtpResponse>> sendOtp({
    required SendOtpRequest requestData,
  });

  Future<DataState<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest requestData,
  });

  Future<DataState<bool>> googleSignIn();

  Future<DataState<bool>> signOut();
}

class AuthRepositoryImpl implements AuthRepository {
  final DioClient client;
  final FirebaseAuth auth;
  final FirebaseFirestore firebaseFirestore;

  AuthRepositoryImpl({
    required this.firebaseFirestore,
    required this.client,
    required this.auth,
  });

  @override
  Future<DataState<SendOtpResponse>> sendOtp({
    required SendOtpRequest requestData,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      return DataSuccess(
        data: SendOtpResponse(
          true,
          "Otp send successfully",
          SendOtpResponseData("12345", "2025-10-15T14:30:00Z"),
        ),
      );

      // final response = await client.post(
      //   ApiEndpoints.sendOtp,
      //   requestData.toJson(),
      // );
      //
      // if (response.statusCode == 200) {
      //   return DataSuccess(data: SendOtpResponse.fromJson(response.data));
      // }

      // return DataError(message: "Server Error! Please try after sometime");
    } catch (e) {
      final errorMessage = AppExceptions.fromException(e);
      return DataError(message: errorMessage.message);
    }
  }

  @override
  Future<DataState<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest requestData,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final dummyVerifyOtpResponse = VerifyOtpResponse(
        status: true,
        message: "OTP verified successfully",
        data: VerifyResponseData(
          otp: "123456",
          userId: "USR001",
          token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
          name: "Ankush Gaur",
          email: "ankush@example.com",
          mobile: "+911234567890",
          userType: "customer",
          profilePic: "https://example.com/profile_pics/ankush.png",
          isVerified: true,
          isActive: true,
          createdAt: "2025-10-15T10:00:00Z",
          updatedAt: "2025-10-15T12:30:00Z",
          deletedAt: null,
        ),
      );

      return DataSuccess(data: dummyVerifyOtpResponse);
    } catch (e) {
      final errorMessage = AppExceptions.fromException(e);
      return DataError(message: errorMessage.message);
    }
  }

  @override
  Future<DataState<bool>> googleSignIn() async {
    try {
      // await GoogleSignIn.instance. ;

      return DataSuccess(data: true);
    } catch (e) {
      final errorMessage = AppExceptions.fromException(e);
      return DataError(message: errorMessage.message);
    }
  }

  @override
  Future<DataState<LoginResponse>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return DataSuccess(
        data: LoginResponse(
          status: true,
          message: "Login Successful",
          user: result.user,
        ),
      );
    } on FirebaseAuthException catch (e) {
      return DataError(message: e.code);
    } catch (e) {
      final errorMessage = AppExceptions.fromException(e);
      return DataError(message: errorMessage.message);
    }
  }

  @override
  Future<DataState<User>> signUp({required SignUpRequest requestData}) async {
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
        email: requestData.email,
        password: requestData.password,
      );

      if (result.user == null) {
        return DataError(message: "Something Went Wrong! Please try again..");
      }

      await result.user!.sendEmailVerification();

      await result.user!.updateProfile(
        displayName: "${requestData.fName} ${requestData.lName}",
      );

      final fcmToken = await FirebaseMessaging.instance.getToken();

      await firebaseFirestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'email': requestData.email,
        'phone': "",
        'name': "${requestData.fName} ${requestData.lName}",
        'photoUrl':
            "https://static.vecteezy.com/system/resources/previews/019/879/186/large_2x/user-icon-on-transparent-background-free-png.png",
        'gender': "",
        'dob': "",
        'address': "",
        'city': "",
        'state': "",
        'country': "",
        'zipCode': "",
        'fcmToken': fcmToken,
        'about': "",
        'bio': "",
        'isVerified': false,
        'isActive': true,
        'userType': "customer",
        'isBlocked': false,
        'isSuspended': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'deletedAt': null,
      });

      return DataSuccess(data: result.user!);
    } on FirebaseAuthException catch (e) {
      return DataError(message: e.code);
    } catch (e) {
      final errorMessage = AppExceptions.fromException(e);
      return DataError(message: errorMessage.message);
    }
  }

  @override
  Future<DataState<bool>> signOut() async {
    try {
      await auth.signOut();
      return DataSuccess(data: true);
    } catch (e) {
      final errorMessage = AppExceptions.fromException(e);
      return DataError(message: errorMessage.message);
    }
  }
}

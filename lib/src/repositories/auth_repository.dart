import 'package:leam/src/core/app_exceptions.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/core/data/remote/dio_client.dart';
import 'package:leam/src/models/auth/request/send_otp_request.dart';
import 'package:leam/src/models/auth/request/verify_otp_request.dart';
import 'package:leam/src/models/auth/response/send_otp_response.dart';
import 'package:leam/src/models/auth/response/verify_otp_response.dart';

abstract class AuthRepository {
  Future<DataState<SendOtpResponse>> sendOtp({
    required SendOtpRequest requestData,
  });

  Future<DataState<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest requestData,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final DioClient client;

  AuthRepositoryImpl({required this.client});

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
}

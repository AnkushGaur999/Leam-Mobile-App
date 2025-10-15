import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leam/src/config/routes/app_routes.dart';
import 'package:leam/src/core/constants/app_colors.dart';
import 'package:leam/src/models/auth/request/send_otp_request.dart';
import 'package:leam/src/models/auth/request/verify_otp_request.dart';
import 'package:leam/src/viewmodels/auth/auth_view_model.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpScreen({super.key, required this.mobileNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  late Timer _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _resendOtp() {
    final request = SendOtpRequest(
      phoneNumber: widget.mobileNumber,
      deviceId: "1232145",
    );
    context.read<AuthViewModel>().add(SendOtpEvent(request));
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthViewModel, AuthState>(
        listener: (context, state) {
          if (state is VerifyOtpSuccess) {
            context.goNamed(AppRoutes.dashboard);
          } else if (state is VerifyOtpFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  Image.asset(
                    'assets/images/app_logo.png',
                    // Replace with your logo asset
                    height: 120,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.apps, size: 100), // Placeholder
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Verification Code',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We have sent the verification\n code to ${widget.mobileNumber}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  Pinput(
                    controller: _otpController,
                    length: 4,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                    ),

                    onCompleted: (pin) {
                      final request = VerifyOtpRequest(
                        mobileNumber: widget.mobileNumber,
                        otp: pin,
                      );
                      context.read<AuthViewModel>().add(
                        VerifyOtpEvent(request),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  if (state is VerifyOtpLoading)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fixedSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          final otp = _otpController.text;
                          if (otp.length == 6) {
                            final request = VerifyOtpRequest(
                              mobileNumber: widget.mobileNumber,
                              otp: otp,
                            );
                            context.read<AuthViewModel>().add(
                              VerifyOtpEvent(request),
                            );
                          }
                        },
                        child: const Text('Verify'),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _start > 0
                            ? 'Resend code in $_start s'
                            : "Didn't receive the code?",
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (_start == 0)
                        TextButton(
                          onPressed: _resendOtp,
                          child: const Text('Resend OTP'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

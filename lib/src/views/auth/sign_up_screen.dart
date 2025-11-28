import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leam/src/config/routes/app_routes.dart';
import 'package:leam/src/models/auth/request/sign_up_request.dart';
import 'package:leam/src/viewmodels/auth/auth_view_model.dart';
import 'package:leam/src/views/auth/widgets/email_text_field.dart';
import 'package:leam/src/views/auth/widgets/password_text_field.dart';
import 'package:leam/src/views/auth/widgets/person_name_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  //  final TextEditingController _mobileNumberController = TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    //  _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;

          const double maxContentWidth = 600.0;

          final double horizontalPadding = (maxWidth > maxContentWidth)
              ? (maxWidth - maxContentWidth) / 2
              : 24.0;

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                // The content itself will now effectively be constrained by `maxContentWidth`
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    _buildHeader(),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          PersonNameTextField(
                            controller: _fNameController,
                            labelText: "First Name",
                            errorText: "First Name is required",
                          ),
                          const SizedBox(height: 20),

                          PersonNameTextField(
                            controller: _lNameController,
                            labelText: "Last Name",
                            errorText: "Last Name is required",
                          ),

                          const SizedBox(height: 20),
                          EmailTextField(controller: _emailController),
                          const SizedBox(height: 20),
                          PasswordTextField(
                            label: "New Password",
                            errorText: "New Password is required",
                            controller: _newPasswordController,
                            isPasswordObscure: _isNewPasswordVisible,
                            passwordToggle: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                          ),

                          const SizedBox(height: 20),

                          PasswordTextField(
                            label: "Confirm Password",
                            errorText: "Confirm Password is required",
                            controller: _confirmPasswordController,
                            isPasswordObscure: _isConfirmPasswordVisible,
                            passwordToggle: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSignUpButton(theme),
                    const SizedBox(height: 24),
                    _buildTermsAndConditions(theme),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Image.asset("assets/images/app_logo.png", height: 120),
        const SizedBox(height: 16),
        Text(
          "Create Account",
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Start your journey with us.",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(ThemeData theme) {
    return BlocConsumer<AuthViewModel, AuthStates>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              content: Text(
                "User registered successfully.\nWe’ve sent a verification link to your email. Please verify your email to continue.",
              ),
            ),
          );

          context.goNamed(AppRoutes.login);
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is SignUpLoading;

        return ElevatedButton(
          onPressed: isLoading ? null : _handleSignUp,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: theme.primaryColor,
            disabledBackgroundColor: theme.primaryColor.withValues(alpha: 0.6),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTermsAndConditions(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: theme.textTheme.bodySmall,
          children: [
            const TextSpan(text: 'By continuing, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
              // recognizer: TapGestureRecognizer()
              //   ..onTap = () => launchUrl(Uri.parse('your_terms_url')),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
              // recognizer: TapGestureRecognizer()
              //   ..onTap = () => launchUrl(Uri.parse('your_privacy_policy_url')),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      final fName = _fNameController.text;
      final lName = _lNameController.text;
      final email = _emailController.text;
      final newPassword = _newPasswordController.text;
      final confirmPassword = _confirmPasswordController.text;

      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      } else {
        context.read<AuthViewModel>().add(
          SignUpEvent(
            signUpRequestData: SignUpRequest(
              fName: fName,
              lName: lName,
              email: email,
              password: newPassword,
            ),
          ),
        );
      }
    }
  }
}

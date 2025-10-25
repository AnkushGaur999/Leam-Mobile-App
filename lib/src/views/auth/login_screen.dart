import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:leam/src/config/routes/app_routes.dart';
import 'package:leam/src/models/auth/request/login_request.dart';
import 'package:leam/src/viewmodels/auth/auth_view_model.dart';
import 'package:leam/src/views/auth/widgets/email_text_field.dart';
import 'package:leam/src/views/auth/widgets/password_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleGoogleSignIn() async {
    // Implement Google sign-in logic
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 1. Horizontal Centering Logic
          final double maxWidth = constraints.maxWidth;
          const double maxContentWidth = 500.0;

          // Calculates padding to push the content to the center on wide screens
          final double horizontalPadding = (maxWidth > maxContentWidth)
              ? (maxWidth - maxContentWidth) / 2
              : 24.0;

          final bool isWideScreen = maxWidth > 800;

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, // Applied calculated padding
                      vertical: 24.0,
                    ),
                    child: Column(
                      // 3. Vertical Centering Logic: Aligns content in the middle
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Spacer helps distribute extra vertical space above and below the content
                        if (isWideScreen) const Spacer(),

                        _buildHeader(),

                        if (isWideScreen)
                          const SizedBox(height: 48)
                        else
                          const SizedBox(height: 24),

                        // --- FORM SECTION ---
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              EmailTextField(controller: _emailController),
                              const SizedBox(height: 20),
                              PasswordTextField(
                                label: "Password",
                                errorText: "Password is required",
                                controller: _passwordController,
                                isPasswordObscure: _isPasswordVisible,
                                passwordToggle: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        // --- END FORM SECTION ---
                        const SizedBox(height: 24),
                        _buildLoginButton(theme),
                        _doNotHaveAccountTextField(),

                        const SizedBox(height: 24),
                        _buildDivider(),

                        const SizedBox(height: 24),
                        _buildGoogleSignInButton(),

                        // Spacer balances the vertical space on wide screens
                        if (isWideScreen) const Spacer(),

                        _buildTermsAndConditions(theme),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
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
          "Welcome",
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Log in to continue your journey.",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return BlocConsumer<AuthViewModel, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.goNamed(AppRoutes.dashboard);
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return ElevatedButton(
          onPressed: isLoading ? null : _handleLoginWithEmailAndPassword,
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
                  "LOGIN",
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

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("OR", style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        IconButton(
          onPressed: _handleGoogleSignIn,
          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
        ),
      ],
    );
  }

  Widget _doNotHaveAccountTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            const TextSpan(text: "Don\'t have account?"),
            TextSpan(
              text: " Create Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.pushNamed(AppRoutes.signUp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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

  void _handleLoginWithEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      context.read<AuthViewModel>().add(
        LoginEvent(
          loginRequestData: LoginRequest(email: email, password: password),
        ),
      );
    }
  }
}

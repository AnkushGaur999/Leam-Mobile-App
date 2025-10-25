import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final String label;
  final String errorText;
  final TextEditingController controller;
  final bool isPasswordObscure;
  final VoidCallback passwordToggle;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.errorText,
    required this.label,
    required this.isPasswordObscure,
    required this.passwordToggle,

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            !isPasswordObscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: passwordToggle,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}

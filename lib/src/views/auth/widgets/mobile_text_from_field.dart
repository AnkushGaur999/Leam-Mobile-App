import 'package:flutter/material.dart';

class MobileTextFromField extends StatelessWidget {
  final TextEditingController controller;

  const MobileTextFromField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Mobile",
        prefixIcon: Icon(Icons.phone_android_rounded),
        prefixText: '+91',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your mobile number";
        }
        if (value.length < 10) {
          return 'Mobile number is invalid';
        }
        return null;
      },
    );
  }
}

import 'package:flutter/material.dart';

class PersonNameTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String errorText;

  const PersonNameTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),

      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
        return null;
      },
    );
  }
}

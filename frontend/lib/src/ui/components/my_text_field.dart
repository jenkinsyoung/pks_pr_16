import 'package:flutter/material.dart';


class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  const MyTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        label: Text(hintText),
        hintText: hintText,
        hintStyle: const TextStyle(
            color:  Color.fromRGBO(76, 23, 0, 1.0)
        ),
      ),

    );
  }
}

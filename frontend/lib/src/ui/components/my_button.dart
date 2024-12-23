import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({
    super.key,
    required this.onTap,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(129, 40, 0, 1.0),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Center(
          child: Text(text, style:
            const TextStyle(
              color: Color.fromRGBO(129, 40, 0, 1.0),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),),
        ),
      ),
    );
  }
}

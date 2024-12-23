import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromRGBO(255, 156, 89, 1.0),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Color.fromRGBO(129, 40, 0, 1),
          fontSize: 16,
        ),
      ),
    );
  }
}

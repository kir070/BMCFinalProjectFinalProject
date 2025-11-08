import 'package:flutter/material.dart';

// STREETWEAR APP COLORS
const Color kDarkGray = Color(0xFF2A3440);
const Color kMediumGray = Color(0xFFA0A6AD);
const Color kLightGray = Color(0xFFDCE0E3);
const Color kWhite = Color(0xFFF8FAFC);

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isCurrentUser ? kDarkGray : kLightGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isCurrentUser ? kWhite : kDarkGray,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}


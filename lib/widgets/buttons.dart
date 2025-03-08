import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
    this.text, {
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Makes the button stretch fully
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF7A122), // Button color
          foregroundColor: Colors.white, // Text color
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Soft rounded edges
          ),
          elevation: 4, // Subtle shadow effect
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(width: 24),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

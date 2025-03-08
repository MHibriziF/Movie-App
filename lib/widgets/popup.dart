import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  const Popup({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    );
  }
}

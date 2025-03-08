import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  const Popup({
    super.key,
    required this.title,
    required this.content,
    required this.onOk,
  });

  final String title;
  final String content;
  final void Function()? onOk;

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
          onPressed: onOk,
          child: const Text("OK"),
        ),
      ],
    );
  }
}

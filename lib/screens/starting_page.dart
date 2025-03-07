import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_app/services/api_services.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: ApiServices.register,
          child: const Text("Register"),
        ),
      ),
    );
  }
}

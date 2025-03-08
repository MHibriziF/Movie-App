import 'package:flutter/material.dart';
import 'package:movie_app/screens/login_screen.dart';
import 'package:movie_app/services/authentication_services.dart';
import 'package:movie_app/widgets/buttons.dart';
import 'package:movie_app/widgets/fullscreen_carousel.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const FullscreenSlider(),
        Positioned.fill(
          bottom: 50.0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(35, 0, 0, 0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Wrap content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to MovieApp",
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: const Color.fromARGB(255, 247, 161, 34),
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 100),
                    AuthButton(
                      "Login",
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 15),
                    AuthButton(
                      "Register",
                      onPressed: Authentication.register,
                      icon: Icons.person_2_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

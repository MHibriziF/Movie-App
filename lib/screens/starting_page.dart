import 'package:flutter/material.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/widgets/buttons.dart';
import 'package:movie_app/widgets/fullscreen_carousel.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FullscreenSlider(),
        Positioned.fill(
          bottom: 50.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Welcome to MovieApp",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: const Color.fromARGB(255, 247, 161, 34),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Positioned.fill(
          bottom: 50.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AuthButton(
                  "Login",
                  onPressed: () {},
                  icon: Icons.person,
                ),
                SizedBox(height: 30.0),
                AuthButton(
                  "Register",
                  onPressed: ApiServices.register,
                  icon: Icons.person_2_outlined,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

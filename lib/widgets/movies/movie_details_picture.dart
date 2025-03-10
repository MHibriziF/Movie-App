import 'package:flutter/material.dart';
import 'package:movie_app/screens/mainscreens/movie_details_screen.dart';

class MovieDetailsPicture extends StatelessWidget {
  const MovieDetailsPicture({
    super.key,
    required this.widget,
  });

  final MovieDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: widget.movie,
          child: Image.network(
            "https://image.tmdb.org/t/p/w500${widget.movie.backDropPath}",
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 150, // Adjust height of the gradient
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  const Color.fromARGB(0, 0, 0, 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

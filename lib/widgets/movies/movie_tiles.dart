import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';

class MovieTiles extends StatelessWidget {
  const MovieTiles({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.network(
          "https://image.tmdb.org/t/p/w200${movie.backDropPath}",
          fit: BoxFit.cover,
          width: 80,
          height: 100,
        ),
        title: Text(movie.title),
      ),
    );
  }
}

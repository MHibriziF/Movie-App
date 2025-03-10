import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_details.dart';

class MovieGenres extends StatelessWidget {
  const MovieGenres({
    super.key,
    required this.movie,
  });

  final MovieDetails movie;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: movie.genres.map((genre) {
        return Chip(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          label: Text(
            genre.name,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        );
      }).toList(),
    );
  }
}

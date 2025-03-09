import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/movie_details.dart';
import 'package:movie_app/services/api_services.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key, required this.movie});
  final Movie movie;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        title: Text(
          widget.movie.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: FutureBuilder(
        future: ApiServices.getMovieDetails(widget.movie.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else {
            final movie = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MovieDetailsPicture(widget: widget),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        MovieRatings(movie: movie),
                        const SizedBox(height: 15),
                        Text(
                          "Genres:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        MovieGenres(movie: movie),
                        const SizedBox(height: 20),
                        Text(
                          "Overview:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.overview,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class MovieRatings extends StatelessWidget {
  const MovieRatings({
    super.key,
    required this.movie,
  });

  final MovieDetails movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 20),
        const SizedBox(width: 5),
        Text(
          movie.voteAverage.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '(${movie.voteCount} votes)',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

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

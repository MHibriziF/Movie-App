import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/mainscreens/movie_details_screen.dart';
import 'package:movie_app/widgets/movie_backdrop.dart';

class MovieList extends StatefulWidget {
  const MovieList({
    super.key,
    required this.title,
    required this.loadMovies,
  });

  final String title;
  final Future<List<Movie>> Function() loadMovies;

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late Future<List<Movie>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() {
    setState(() {
      _favoritesFuture = widget.loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<Movie>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No ${widget.title} yet.'));
          }

          List<Movie> movies = snapshot.data!;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, ind) {
              double height = MediaQuery.of(context).size.height * 0.4;
              return GestureDetector(
                onTap: () async {
                  // Wait for the user to return from detail page
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsScreen(
                        movie: movies[ind],
                      ),
                    ),
                  );
                  // Refresh the favorites list when coming back
                  _loadMovies();
                },
                child: SizedBox(
                  height: height,
                  child: MovieBackdrop(movie: movies[ind]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/widgets/movies/movie_details_picture.dart';
import 'package:movie_app/widgets/movies/movie_genres.dart';
import 'package:movie_app/widgets/movies/movie_ratings.dart';
import 'package:movie_app/widgets/popup.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key, required this.movie});
  final Movie movie;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool isFavorite = false;
  bool isWatchlist = false;

  @override
  Widget build(BuildContext context) {
    var authBox = Hive.box("authBox");
    bool isLoggedIn = authBox.get('session_id') != null;
    if (isLoggedIn) {
      var favBox = Hive.box('favoritesBox');
      var watchlistBox = Hive.box('watchlistBox');
      isFavorite = favBox.get(widget.movie.id) != null;
      isWatchlist = watchlistBox.get(widget.movie.id) != null;
    }

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
        actions: [
          if (isLoggedIn)
            IconButton(
              onPressed: () => handleFavorites(isFavorite),
              icon: isFavorite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
            ),
        ],
      ),
      body: FutureBuilder(
        future: ApiServices.getMovieDetails(widget.movie.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Details are not available'));
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
                        Row(
                          children: [
                            MovieRatings(movie: movie),
                            const Spacer(),
                            if (isLoggedIn)
                              CircleAvatar(
                                child: IconButton(
                                  onPressed: () => handleWatchlist(isWatchlist),
                                  icon: isWatchlist
                                      ? Icon(Icons.movie_creation_sharp)
                                      : Icon(Icons.movie_creation_outlined),
                                ),
                              ),
                          ],
                        ),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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

  void handleWatchlist(bool isWatchlist) async {
    if (!isWatchlist) {
      addToWatchlist();
    } else {
      showDialog(
        context: context,
        builder: (context) => Popup(
          title: "Remove from watchlist?",
          content:
              "Are you sure you want to remove this movie from your watchlist?",
          onOk: () {
            Navigator.of(context).pop();
            removeFromWatchlist();
          },
        ),
      );
    }
  }

  void addToWatchlist() async {
    int responseCode = await ApiServices.updateWatchlist({
      "media_type": "movie",
      "media_id": widget.movie.id,
      "watchlist": true,
    });
    if (responseCode == 201) {
      var watchBox = Hive.box('watchlistBox');
      watchBox.put(widget.movie.id, true);
      setState(() {
        isWatchlist = watchBox.get(widget.movie.id) != null;
      });
    }
  }

  void removeFromWatchlist() async {
    int responseCode = await ApiServices.updateWatchlist({
      "media_type": "movie",
      "media_id": widget.movie.id,
      "watchlist": false,
    });
    if (responseCode == 200) {
      var watchBox = Hive.box('watchlistBox');
      watchBox.delete(widget.movie.id);
      setState(() {
        isWatchlist = watchBox.get(widget.movie.id) != null;
      });
    }
  }

  void handleFavorites(bool isFavorite) async {
    if (!isFavorite) {
      addToFavorites();
    } else {
      showDialog(
          context: context,
          builder: (context) => Popup(
                title: "Remove from favorites?",
                content:
                    "Are you sure you want to remove this movie from your favorites?",
                onOk: () {
                  Navigator.of(context).pop();
                  removeFromFavorites();
                },
              ));
    }
  }

  void addToFavorites() async {
    int responseCode = await ApiServices.updateFavorites({
      "media_type": "movie",
      "media_id": widget.movie.id,
      "favorite": true,
    });
    if (responseCode == 201) {
      var favBox = Hive.box('favoritesBox');
      favBox.put(widget.movie.id, true);
      setState(() {
        isFavorite = favBox.get(widget.movie.id) != null;
      });
    }
  }

  void removeFromFavorites() async {
    int responseCode = await ApiServices.updateFavorites({
      "media_type": "movie",
      "media_id": widget.movie.id,
      "favorite": false,
    });
    if (responseCode == 200) {
      var favBox = Hive.box('favoritesBox');
      favBox.delete(widget.movie.id);
      setState(() {
        isFavorite = favBox.get(widget.movie.id) != null;
      });
    }
  }
}

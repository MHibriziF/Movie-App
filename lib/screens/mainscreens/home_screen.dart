import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/widgets/left_drawer.dart';
import 'package:movie_app/widgets/row_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    loadUserDatas();
  }

  void loadUserDatas() async {
    var favBox = await Hive.openBox("favoritesBox");
    var watchBox = await Hive.openBox("watchlistBox");

    final List<Movie> favoriteMovies = await ApiServices.getFavorites();
    for (var movie in favoriteMovies) {
      favBox.put(movie.id, true);
    }

    final List<Movie> watchlist = await ApiServices.getWatchList();
    for (var movie in watchlist) {
      watchBox.put(movie.id, true);
    }
  }

  Future<Map<String, List<Movie>>> getBrowsingMovies() async {
    final nowPlaying = await ApiServices.getNowPlaying(1);
    final popular = await ApiServices.getPopular(1);
    final topRated = await ApiServices.getTopRated(1);
    final upcoming = await ApiServices.getUpcoming(1);
    return {
      'nowPlaying': nowPlaying,
      'popular': popular,
      'topRated': topRated,
      'upcoming': upcoming,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MovieApp',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ),
      drawer: LeftDrawer(),
      body: FutureBuilder<Map<String, List<Movie>>>(
        future: getBrowsingMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load data'),
            );
          } else {
            return ListView(
              children: [
                const SizedBox(height: 10),
                MovieCategoryLabel(
                  'Now Playing',
                  isBiggest: true,
                ),
                const SizedBox(height: 10),
                RowCarousel(
                  movieList: snapshot.data!['nowPlaying']!,
                  percent: 0.3,
                ),
                const SizedBox(height: 10),
                MovieCategoryLabel('Top Rated'),
                const SizedBox(height: 10),
                RowCarousel(
                  movieList: snapshot.data!['topRated']!,
                  percent: 0.25,
                  viewportFraction: 0.6,
                ),
                const SizedBox(height: 10),
                MovieCategoryLabel('Popular'),
                const SizedBox(height: 10),
                RowCarousel(
                  movieList: snapshot.data!['popular']!,
                  percent: 0.25,
                  viewportFraction: 0.6,
                ),
                const SizedBox(height: 10),
                MovieCategoryLabel('Upcoming'),
                const SizedBox(height: 10),
                RowCarousel(
                  movieList: snapshot.data!['upcoming']!,
                  percent: 0.25,
                  viewportFraction: 0.6,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class MovieCategoryLabel extends StatelessWidget {
  const MovieCategoryLabel(
    this.category, {
    super.key,
    this.isBiggest = false,
  });

  final String category;
  final bool isBiggest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        category,
        style: isBiggest
            ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                )
            : Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
      ),
    );
  }
}

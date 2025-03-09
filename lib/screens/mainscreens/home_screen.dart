import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/widgets/row_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, List<Movie>>> getBrowsingMovies() async {
    final nowPlaying = await ApiServices.getNowPlaying(1);
    final popular = await ApiServices.getPopular(1);
    final topRated = await ApiServices.getTopRated(1);
    return {
      'nowPlaying': nowPlaying,
      'popular': popular,
      'topRated': topRated,
    };
  }

  Widget movieCategoryLabel(String category, bool isBiggest) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MovieApp',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
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
                movieCategoryLabel('Now Playing', true),
                const SizedBox(height: 10),
                RowCarousel(
                  movieList: snapshot.data!['nowPlaying']!,
                  percent: 0.3,
                ),
                const SizedBox(height: 10),
                movieCategoryLabel('Top Rated', false),
                const SizedBox(height: 10),
                RowCarousel(
                  movieList: snapshot.data!['topRated']!,
                  percent: 0.25,
                  viewportFraction: 0.6,
                ),
                const SizedBox(height: 10),
                movieCategoryLabel('Popular', false),
                const SizedBox(height: 10),
                RowCarousel(
                  movieList: snapshot.data!['popular']!,
                  percent: 0.25,
                  viewportFraction: 0.6,
                ),
                const SizedBox(height: 10),
              ],
            );
          }
        },
      ),
    );
  }
}

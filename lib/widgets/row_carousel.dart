import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/widgets/movie_backdrop.dart';

class RowCarousel extends StatelessWidget {
  const RowCarousel({
    super.key,
    required this.movieList,
    required this.percent,
    this.viewportFraction,
  });

  final List<Movie> movieList;
  final double percent;
  final double? viewportFraction;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * percent,
        autoPlay: true,
        viewportFraction: viewportFraction ?? 0.8,
        enlargeCenterPage: true,
      ),
      items: movieList
          .map(
            (movie) => MovieBackdrop(
              path: movie.backDropPath,
              movieTitle: movie.title,
            ),
          )
          .toList(),
    );
  }
}

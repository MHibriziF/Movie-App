import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';

class MovieBackdrop extends StatelessWidget {
  const MovieBackdrop({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: movie,
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500${movie.backDropPath}",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(113, 0, 0, 0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

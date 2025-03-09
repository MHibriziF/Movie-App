import 'package:flutter/material.dart';

class MovieBackdrop extends StatelessWidget {
  const MovieBackdrop({
    super.key,
    required this.path,
    required this.movieTitle,
  });

  final String path;
  final String movieTitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500$path",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      movieTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
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

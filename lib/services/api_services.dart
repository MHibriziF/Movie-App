import 'dart:convert';
import 'package:movie_app/models/movie.dart';
import '../env.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<List<Movie>> getNowPlaying(int page) async {
    final uri = Uri.https(
      Env.baseUrl,
      "/3/movie/now_playing",
      {
        'api_key': Env.apiKey,
        'page': page.toString(),
      },
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }

  static Future<List<Movie>> searchMovie(String movieName) async {
    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/search/movie',
      {'api_key': Env.apiKey, 'query': movieName},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = data.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

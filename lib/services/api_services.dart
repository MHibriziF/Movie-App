import 'dart:convert';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/movie_details.dart';
import '../env.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static List<Movie> convertResponseToMovieList(http.Response response) {
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = [];
      for (final movie in data) {
        try {
          movies.add(Movie.fromJson(movie));
        } catch (e) {
          continue;
        }
      }
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }

  static Future<MovieDetails> getMovieDetails(int id) async {
    final uri = Uri.https(
      Env.baseUrl,
      "/3/movie/$id",
      {
        'api_key': Env.apiKey,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetails.fromJson(data);
    } else {
      throw Exception("Failed to load data");
    }
  }

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
    return convertResponseToMovieList(response);
  }

  static Future<List<Movie>> getPopular(int page) async {
    final uri = Uri.https(
      Env.baseUrl,
      "/3/movie/popular",
      {
        'api_key': Env.apiKey,
        'page': page.toString(),
      },
    );
    final response = await http.get(uri);
    return convertResponseToMovieList(response);
  }

  static Future<List<Movie>> getTopRated(int page) async {
    final uri = Uri.https(
      Env.baseUrl,
      "/3/movie/top_rated",
      {
        'api_key': Env.apiKey,
        'page': page.toString(),
      },
    );
    final response = await http.get(uri);
    return convertResponseToMovieList(response);
  }

  static Future<List<Movie>> searchMovie(String movieName) async {
    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/search/movie',
      {'api_key': Env.apiKey, 'query': movieName},
    );

    final response = await http.get(uri);
    return convertResponseToMovieList(response);
  }
}

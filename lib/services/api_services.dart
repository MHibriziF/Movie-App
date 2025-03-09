import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:movie_app/models/account.dart';
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
      Env.baseUrl,
      '/3/search/movie',
      {'api_key': Env.apiKey, 'query': movieName},
    );

    final response = await http.get(uri);
    return convertResponseToMovieList(response);
  }

  static Future<Account> getAccountDetails() async {
    var box = Hive.box('authBox');
    final uri = Uri.https(
      Env.baseUrl,
      '/3/account',
      {
        'api_key': Env.apiKey,
        'session_id': box.get('session_id'),
      },
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Account.fromJson(data);
    } else {
      throw Exception("Failed to load data");
    }
  }

  static Future<int> updateFavorites(Map<String, dynamic> requestBody) async {
    var box = Hive.box('authBox');

    final uri = Uri.https(
      Env.baseUrl,
      "/3/account/1/favorite",
      {
        'api_key': Env.apiKey,
        'session_id': box.get('session_id'),
      },
    );

    final response = await http.post(
      uri,
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode;
  }

  static Future<List<Movie>> getFavorites() async {
    var box = Hive.box('authBox');

    final uri = Uri.https(
      Env.baseUrl,
      '/3/account/1/favorite/movies',
      {
        'api_key': Env.apiKey,
        'session_id': box.get('session_id'),
      },
    );
    final response = await http.get(uri);
    return convertResponseToMovieList(response);
  }

  static Future<int> updateWatchlist(Map<String, dynamic> requestBody) async {
    var box = Hive.box('authBox');

    final uri = Uri.https(
      Env.baseUrl,
      "/3/account/1/watchlist",
      {
        'api_key': Env.apiKey,
        'session_id': box.get('session_id'),
      },
    );

    final response = await http.post(
      uri,
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode;
  }

  static Future<List<Movie>> getWatchList() async {
    var box = Hive.box('authBox');

    final uri = Uri.https(
      Env.baseUrl,
      '/3/account/1/watchlist/movies',
      {
        'api_key': Env.apiKey,
        'session_id': box.get('session_id'),
      },
    );
    final response = await http.get(uri);
    return convertResponseToMovieList(response);
  }
}

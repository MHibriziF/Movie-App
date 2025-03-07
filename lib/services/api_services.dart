import 'dart:convert';
import 'package:movie_app/models/movie.dart';
import '../env.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<List<Movie>> getNowPlaying() async {
    final url = Uri.parse(
        '${Env.baseUrl}/movie/now_playing?api_key=${Env.apiKey}'); // 1
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }
}

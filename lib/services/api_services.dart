import 'dart:convert';
import 'package:movie_app/models/movie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../env.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static void register() async {
    final uri = Uri.parse("https://www.themoviedb.org/signup");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
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
    ); // 1
    final response = await http.get(uri); // 2

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }
}

import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../env.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/request_token.dart';
import 'package:hive/hive.dart';

class Authentication {
  static void register() async {
    final uri = Uri.parse("https://www.themoviedb.org/signup");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    }
  }

  static Future<RequestToken> getRequestToken() async {
    final uri = Uri.https(
      Env.baseUrl,
      "/3/authentication/token/new",
      {
        'api_key': Env.apiKey,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final requestTokenModel = RequestToken.fromJson(data);
      return requestTokenModel;
    } else {
      throw Exception("Failed to load data");
    }
  }

  static Future<RequestToken> validateWithLogin(
      Map<String, dynamic> requestBody) async {
    final uri = Uri.https(
      Env.baseUrl,
      "/3/authentication/token/validate_with_login",
      {
        'api_key': Env.apiKey,
      },
    );
    final response = await http.post(
      uri,
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );
    final data = json.decode(response.body);
    return RequestToken.fromJson(data);
  }

  static Future<String> createSession(Map<String, dynamic> requestBody) async {
    final uri = Uri.https(
      Env.baseUrl,
      "/3/authentication/session/new",
      {
        'api_key': Env.apiKey,
      },
    );
    final response = await http.post(
      uri,
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        String sessionId = data['session_id'];

        // Store session ID in Hive
        var box = Hive.box('sessionBox');
        await box.put('session_id', sessionId);

        return sessionId;
      }
      return "Fail";
    } else {
      throw Exception("Failed to load data");
    }
  }

  static Future<bool> deleteSession(String sessionId) async {
    final uri = Uri.https(
      Env.baseUrl,
      "/3/authentication/session",
      {
        'api_key': Env.apiKey,
        'session_id': sessionId,
      },
    );
    final response = await http.delete(uri);
    final data = json.decode(response.body);

    if (data['success']) {
      // Delete session ID in Hive
      var box = Hive.box('sessionBox');
      await box.delete('session_id');
      return data['success'];
    }

    return false;
  }
}

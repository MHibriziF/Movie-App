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
    var box = Hive.box('authBox');

    // Use the existing token if it is not expired
    if (!Authentication.isTokenExpired()) {
      String requestToken = box.get('request_token');
      String expiry = box.get('token_expiry');

      return RequestToken(
        success: true,
        expiresAt: expiry,
        requestToken: requestToken,
      );
    }

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
      box.put('request_token', requestTokenModel.requestToken);
      box.put('token_expiry', requestTokenModel.expiresAt);
      return requestTokenModel;
    } else {
      throw Exception("Failed to load data");
    }
  }

  static bool isTokenExpired() {
    var box = Hive.box('authBox');
    String? expiryStr = box.get('token_expiry');
    if (expiryStr == null) {
      return true;
    }

    expiryStr = expiryStr.replaceAll(" UTC", "Z");
    DateTime expiryTime = DateTime.parse(expiryStr);
    DateTime now = DateTime.now().toUtc();
    return now.isAfter(expiryTime);
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
    if (data['success']) {
      return RequestToken.fromJson(data);
    }
    throw Exception("Invalid Username and/or Password");
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
        var box = Hive.box('authBox');
        await box.put('session_id', sessionId);

        // Delete request token
        await box.delete('request_token');
        await box.delete('token_expiry');

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
      // Delete session ID and other user datas in Hive
      var box = Hive.box('authBox');
      var favBox = Hive.box('favoritesBox');
      var watchlistBox = Hive.box('watchlistBox');
      await box.delete('session_id');
      await favBox.clear();
      await watchlistBox.clear();

      return data['success'];
    }

    return false;
  }
}

import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _Env.apiKey;

  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _Env.baseUrl;
}

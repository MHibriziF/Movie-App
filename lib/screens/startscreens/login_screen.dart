import 'package:flutter/material.dart';
import 'package:movie_app/screens/mainscreens/main_screen.dart';
import 'package:movie_app/services/authentication_services.dart';
import 'package:movie_app/widgets/popup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void submitLogin() {
    if (_formKey.currentState!.validate()) {
      login(
        context,
        _usernameController.text,
        _passwordController.text,
      );
    }
  }

  String? nullValidator(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }

  void login(BuildContext context, String username, String password) async {
    final request = await Authentication.getRequestToken();
    try {
      final response = await Authentication.validateWithLogin({
        'username': username,
        'password': password,
        'request_token': request.requestToken,
      });
      var session = await Authentication.createSession({
        'request_token': response.requestToken,
      });
      print(session);
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainPage(title: "Homepage"),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      // Invalid credentials
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => Popup(
            title: "Invalid Username and/or Password",
            content: "Please re-enter your credentials",
            onOk: () => Navigator.pop(context),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sign in with TMDB",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
                SizedBox(height: 50),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    hintText: "Enter your TMDB username",
                  ),
                  validator: (value) => nullValidator(
                    value,
                    'Please enter your username',
                  ),
                ),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your TMDB password",
                  ),
                  obscureText: true,
                  validator: (value) => nullValidator(
                    value,
                    'Please enter your password',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitLogin,
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        minimumSize: WidgetStateProperty.all(
                          const Size(double.infinity, 50),
                        ),
                      ),
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

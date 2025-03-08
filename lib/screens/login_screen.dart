import 'package:flutter/material.dart';
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

  void login(BuildContext context, String username, String password) async {
    final request = await Authentication.getRequestToken();
    try {
      final response = await Authentication.validateWithLogin({
        'username': username,
        'password': password,
        'request_token': request.requestToken,
      });
      await Authentication.createSession({
        'request_token': response.requestToken,
      });
    } catch (e) {
      // Invalid credentials
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => Popup(
            title: "Invalid Username and/or Password",
            content: "Please re-enter your credentials",
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  hintText: "Enter your TMDB username",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    login(
                      context,
                      _usernameController.text,
                      _passwordController.text,
                    );
                  }
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

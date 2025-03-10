import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/mainscreens/movie_list_screen.dart';
import 'package:movie_app/screens/startscreens/login_screen.dart';
import 'package:movie_app/screens/startscreens/starting_page.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/services/authentication_services.dart';
import 'package:movie_app/widgets/popup.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var authBox = Hive.box("authBox");
    bool isLoggedIn = authBox.get('session_id') != null;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              children: [
                Text(
                  'MovieApp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Track and get informations of your favorite movies! ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () =>
                  toMovieList(context, "Favorites", ApiServices.getFavorites),
            ),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.movie_creation_sharp),
              title: const Text('Watchlist'),
              onTap: () =>
                  toMovieList(context, "Watchlist", ApiServices.getWatchList),
            ),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Popup(
                    title: "Confirm Exit",
                    content: "Are you sure you want to logout?",
                    onOk: () => logout(context),
                  ),
                );
              },
            ),
          if (!isLoggedIn)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => StartingPage(),
      ),
      (route) => false,
    );
    Authentication.deleteSession();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text("Succesfully logged out."),
        ),
      );
  }

  void toMovieList(
      BuildContext context, String title, Future<List<Movie>> Function() func) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieList(
          title: title,
          loadMovies: func,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/mainscreens/movie_list_screen.dart';
import 'package:movie_app/screens/startscreens/starting_page.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/services/authentication_services.dart';
import 'package:movie_app/widgets/popup.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () =>
                toMovieList(context, "Favorites", ApiServices.getFavorites),
          ),
          ListTile(
            leading: const Icon(Icons.movie_creation_sharp),
            title: const Text('Watchlist'),
            onTap: () =>
                toMovieList(context, "Watchlist", ApiServices.getWatchList),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
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
          )
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

import 'package:flutter/material.dart';
import 'package:movie_app/screens/startscreens/starting_page.dart';
import 'package:movie_app/services/authentication_services.dart';
import 'package:movie_app/widgets/popup.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  void logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => StartingPage(),
      ),
      (route) => false,
    );
    Authentication.deleteSession();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'MovieApp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Track and get the informations on your favorite movies! ",
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => MyHomePage(),
              //     ));
            },
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
}

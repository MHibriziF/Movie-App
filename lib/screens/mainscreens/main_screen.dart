import 'package:flutter/material.dart';
import 'package:movie_app/screens/mainscreens/discover_screen.dart';
import 'package:movie_app/screens/mainscreens/home_screen.dart';
import 'package:movie_app/screens/mainscreens/profile_screen.dart';
import 'package:movie_app/screens/mainscreens/search.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _navigationIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    DiscoverScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _navigationIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _navigationIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        selectedItemColor: Theme.of(context).colorScheme.onTertiaryContainer,
        showUnselectedLabels: false,
        currentIndex: _navigationIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

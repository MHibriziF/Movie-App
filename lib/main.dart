import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/screens/mainscreens/main_screen.dart';
import 'screens/startscreens/starting_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

final kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 43, 39, 39),
);

final kTheme = ThemeData.dark().copyWith(
  colorScheme: kColorScheme,
  textTheme: GoogleFonts.latoTextTheme().copyWith(
    bodyMedium: TextStyle(
      color: kColorScheme.onPrimaryContainer,
    ),
  ),
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.primaryContainer,
    foregroundColor: kColorScheme.onPrimaryContainer,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorScheme.primaryContainer,
      foregroundColor: kColorScheme.onPrimaryContainer,
    ),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('authBox');
    bool isLoggedIn = box.get('session_id') != null;

    return MaterialApp(
      title: 'Movie App',
      theme: kTheme,
      home: isLoggedIn ? const MainPage() : const StartingPage(),
    );
  }
}

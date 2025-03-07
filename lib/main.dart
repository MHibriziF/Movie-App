import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/starting_page.dart';

final kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 75, 37, 37),
);

final kTheme = ThemeData.dark().copyWith(
  colorScheme: kColorScheme,
  textTheme: GoogleFonts.latoTextTheme(),
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.onPrimaryContainer,
    foregroundColor: kColorScheme.primaryContainer,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorScheme.primaryContainer,
      foregroundColor: kColorScheme.onPrimaryContainer,
    ),
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: kTheme,
      home: const StartingPage(title: 'Starting Page'),
    );
  }
}

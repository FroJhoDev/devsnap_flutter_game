import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui/views/main_menu_screen.dart';

void main() {
  runApp(const DevSnapApp());
}

class DevSnapApp extends StatelessWidget {
  const DevSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevSnap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoMonoTextTheme(Theme.of(context).textTheme),
      ),
      home: const MainMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/menu_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Blocca orientamento verticale
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Nascondi status bar e navigation bar (fullscreen)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const RhythmLegendsApp());
}

class RhythmLegendsApp extends StatelessWidget {
  const RhythmLegendsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rhythm Legends',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MenuPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:orverlap_word_logo_creator/pages/home_page.dart';

import 'pages/logo_create_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const HomePage(),
        '/logo': (context) => const LogoCreatePage(),
      },
      initialRoute: '/',
    );
  }
}

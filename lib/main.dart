import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'app_languages.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppLanguage(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie DB App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0F1E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF01B4E4),
        ),
      ),
      home: const HomePage(),
    );
  }
}
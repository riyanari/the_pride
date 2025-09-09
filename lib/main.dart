import 'package:flutter/material.dart';
import 'package:the_pride/pages/home_page.dart';
import 'package:the_pride/pages/login_page.dart';
import 'package:the_pride/pages/splash_page.dart';
import 'package:the_pride/pages/teori/level1/alphabet_page.dart';
import 'package:the_pride/pages/teori/level1/level1_page.dart';
import 'package:the_pride/pages/teori/level1/pronunciation_page.dart';
import 'package:the_pride/pages/teori/level2/level2_page.dart';
import 'package:the_pride/pages/teori/level3/level3_page.dart';
import 'package:the_pride/pages/teori/level4/level4_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        'level1_page': (context) => Level1Page(),
        'level2_squire': (context) => Level2Page(),
        'level3_knight': (context) => Level3Page(),
        'level4_lord': (context) => Level4Page(),


        '/chapter1/alphabet': (context) => AlphabetPage(),
        '/chapter1/pronunciation': (context) => PronunciationPage(),
        // '/chapter1/punctuation': (context) => PunctuationScreen(),
        // '/chapter2/greeting': (context) => GreetingScreen(),
        // '/chapter2/compliment': (context) => ComplimentScreen(),
        // '/chapter3/family': (context) => FamilyScreen(),
        // '/chapter3/job': (context) => JobScreen(),
        // '/chapter3/hobby': (context) => HobbyScreen(),
      },
    );
  }
}


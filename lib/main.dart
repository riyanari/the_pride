import 'package:flutter/material.dart';
import 'package:the_pride/pages/home_page.dart';
import 'package:the_pride/pages/login_page.dart';
import 'package:the_pride/pages/splash_page.dart';
import 'package:the_pride/pages/teori/level1/chapter1/alphabet/alphabet_page.dart';
import 'package:the_pride/pages/teori/level1/chapter1/pronunciation/pronunciation_page.dart';
import 'package:the_pride/pages/teori/level1/chapter1/punctuation/punctuation_page.dart';
import 'package:the_pride/pages/teori/level1/chapter2/compliment/compliment_page.dart';
import 'package:the_pride/pages/teori/level1/chapter2/greatings_page.dart';
import 'package:the_pride/pages/teori/level1/chapter3/family/family_page.dart';
import 'package:the_pride/pages/teori/level1/chapter3/hobbies/hobbies_page.dart';
import 'package:the_pride/pages/teori/level1/chapter3/jobs/jobs_page.dart';
import 'package:the_pride/pages/teori/level1/chapter4/numbers/numbers_page.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/time_page.dart';
import 'package:the_pride/pages/teori/level1/chapter5/colors/color_page.dart';
import 'package:the_pride/pages/teori/level1/chapter5/foods/food_page.dart';
import 'package:the_pride/pages/teori/level1/chapter6/country/country_page.dart';
import 'package:the_pride/pages/teori/level1/chapter6/map_direction/map_direction_page.dart';
import 'package:the_pride/pages/teori/level1/chapter7/complain_apologize/complain_apologize_page.dart';
import 'package:the_pride/pages/teori/level1/chapter7/gesture/gesture_page.dart';
import 'package:the_pride/pages/teori/level1/chapter8/auxv/basic_auxv_page.dart';
import 'package:the_pride/pages/teori/level1/chapter8/questions/question_word_page.dart';
import 'package:the_pride/pages/teori/level1/level1_page.dart';
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


        '/1/chapter1/alphabet': (context) => AlphabetPage(),
        '/1/chapter1/pronunciation': (context) => PronunciationPage(),
        '/1/chapter1/punctuation': (context) => PunctuationPage(),
        '/1/chapter2/greeting': (context) => GreetingsPage(),
        '/1/chapter2/compliment': (context) => ComplimentsPage(),
        '/1/chapter3/family': (context) => FamilyPage(),
        '/1/chapter3/job': (context) => JobsPage(),
        '/1/chapter3/hobby': (context) => HobbiesPage(),
        '/1/chapter4/number': (context) => NumbersPage(),
        '/1/chapter4/time': (context) => TimePage(),
        '/1/chapter5/food': (context) => FoodPage(),
        '/1/chapter5/color': (context) => ColorPage(),
        '/1/chapter6/country': (context) => CountryPage(),
        '/1/chapter6/map': (context) => MapDirectionPage(),
        '/1/chapter7/gesture': (context) => GesturePage(),
        '/1/chapter7/complain': (context) => ComplainingApologizingPage(),
        '/1/chapter8/question': (context) => QuestionWordPage(),
        '/1/chapter8/auxv': (context) => BasicAuxVPage(),
      },
    );
  }
}


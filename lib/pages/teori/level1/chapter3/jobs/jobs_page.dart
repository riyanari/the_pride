import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';
import 'package:the_pride/pages/teori/level1/chapter3/jobs/tabs/pengertian_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter3/jobs/tabs/penjelasan_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter3/jobs/tabs/kosakata_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter3/jobs/tabs/game_flashcards.dart';
import 'package:the_pride/pages/teori/level1/chapter3/jobs/tabs/game_match.dart';
import 'package:the_pride/pages/teori/level1/chapter3/jobs/tabs/game_mcq.dart';
import 'package:the_pride/pages/teori/level1/chapter3/jobs/tabs/game_picture_match.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const titles = [
      'Pengertian',
      'Penjelasan',
      'Kosakata',
      'Game: Flashcards',
      'Game: Match',
      'Game: MCQ',
      'Game: Picture Match',
    ];

    return Scaffold(
      appBar: CustomAppBar('Jobs & Professions', iconSize: 16.0),
      body: const CustomPageView(
        pageTitles: titles,
        pages: [
          JobsPengertianTab(),
          JobsPenjelasanTab(),
          JobsKosakataTab(),
          JobsFlashcardsGame(),
          JobsMatchGame(),
          JobsMcqGame(),
          JobsPictureMatchGame(),
        ],
        onFinish: null,
      ),
    );
  }
}

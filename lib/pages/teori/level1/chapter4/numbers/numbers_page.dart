import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';
import 'package:the_pride/pages/teori/level1/chapter4/numbers/tabs/pengertian_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter4/numbers/tabs/penjelasan_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter4/numbers/tabs/kosakata_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter4/numbers/tabs/game_flashcards.dart';
import 'package:the_pride/pages/teori/level1/chapter4/numbers/tabs/game_match.dart';
import 'package:the_pride/pages/teori/level1/chapter4/numbers/tabs/game_mcq.dart';
import 'package:the_pride/pages/teori/level1/chapter4/numbers/tabs/game_spelling.dart';

class NumbersPage extends StatelessWidget {
  const NumbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    const titles = [
      'Pengertian',
      'Penjelasan',
      'Kosakata',
      'Game: Flashcards',
      'Game: Match',
      'Game: MCQ',
      'Game: Spelling',
    ];

    return Scaffold(
      appBar: CustomAppBar('Numbers', iconSize: 16.0),
      body: const CustomPageView(
        pageTitles: titles,
        pages: [
          NumbersPengertianTab(),
          NumbersPenjelasanTab(),
          NumbersKosakataTab(),
          NumbersFlashcardsGame(),
          NumbersMatchGame(),
          NumbersMcqGame(),
          NumbersSpellingGame(),
        ],
        onFinish: null,
      ),
    );
  }
}

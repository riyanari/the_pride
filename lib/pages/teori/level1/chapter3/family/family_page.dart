import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';
import 'package:the_pride/pages/teori/level1/chapter3/family/tabs/game_flashcards.dart';
import 'package:the_pride/pages/teori/level1/chapter3/family/tabs/game_match.dart';
import 'package:the_pride/pages/teori/level1/chapter3/family/tabs/game_mcq.dart';
import 'package:the_pride/pages/teori/level1/chapter3/family/tabs/kosakata_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter3/family/tabs/pengertian_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter3/family/tabs/penjelasan_tab.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titles = const [
      'Pengertian',
      'Penjelasan',
      'Kosakata',
      'Game: Flashcards',
      'Game: Match',
      'Game: MCQ',
    ];

    return Scaffold(
      appBar: CustomAppBar('Family', iconSize: 16.0),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          FamilyPengertianTab(),
          FamilyPenjelasanTab(),
          FamilyKosakataTab(),
          FamilyFlashcardsGame(),
          FamilyMatchGame(),
          FamilyMcqGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

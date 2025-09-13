import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';

import 'tabs/gesture_pengertian_tab.dart';
import 'tabs/gesture_penjelasan_tab.dart';
import 'tabs/gesture_vocabulary_tab.dart';
import 'tabs/gesture_game_flashcards.dart';
import 'tabs/gesture_game_match.dart';
import 'tabs/gesture_game_mcq.dart';
import 'tabs/gesture_game_gapfill.dart';

class GesturePage extends StatelessWidget {
  const GesturePage({super.key});

  @override
  Widget build(BuildContext context) {
    const titles = [
      'Pengertian',
      'Penjelasan',
      'Kosakata',
      'Game: Flashcards',
      'Game: Match',
      'Game: MCQ',
      'Game: Gap Fill',
    ];

    return Scaffold(
      appBar: const CustomAppBar('Gestures & Body Language', iconSize: 16),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          GesturePengertianTab(),
          GesturePenjelasanTab(),
          GestureVocabularyTab(),
          GestureFlashcardGame(),
          GestureMatchGame(),
          GestureMCQGame(),
          GestureGapFillGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

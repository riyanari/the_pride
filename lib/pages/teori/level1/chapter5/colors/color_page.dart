import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';

import 'tabs/color_pengertian_tab.dart';
import 'tabs/color_penjelasan_tab.dart';
import 'tabs/color_vocabulary_tab.dart';
import 'tabs/color_game_match.dart';
import 'tabs/color_game_mcq.dart';
import 'tabs/color_game_gapfill.dart';
import 'tabs/color_game_flashcards.dart';

class ColorPage extends StatelessWidget {
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titles = const [
      'Pengertian',
      'Penjelasan',
      'Kosakata',
      'Game: Flashcards',
      'Game: Match',
      'Game: MCQ',
      'Game: Gap Fill',
    ];

    return Scaffold(
      appBar: CustomAppBar('Colors', iconSize: 16),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          ColorPengertianTab(),
          ColorPenjelasanTab(),
          ColorVocabularyTab(),
          ColorFlashcardGame(),
          ColorMatchGame(),
          ColorMCQGame(),
          ColorGapFillGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

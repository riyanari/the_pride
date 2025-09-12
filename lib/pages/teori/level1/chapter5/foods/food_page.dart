import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';

import 'tabs/food_pengertian_tab.dart';
import 'tabs/food_penjelasan_tab.dart';
import 'tabs/food_vocabulary_tab.dart';
import 'tabs/food_game_match.dart';
import 'tabs/food_game_mcq.dart';
import 'tabs/food_game_gapfill.dart';
import 'tabs/food_game_flashcards.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titles = const [
      'Pengertian',
      'Penjelasan',
      'Kosakata',
      'Game: Match',
      'Game: MCQ',
      'Game: Gap Fill',
      'Game: Flashcards',
    ];

    return Scaffold(
      appBar: CustomAppBar('Food & Drinks', iconSize: 16),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          FoodPengertianTab(),
          FoodPenjelasanTab(),
          FoodVocabularyTab(),
          FoodMatchGame(),
          FoodMCQGame(),
          FoodGapFillGame(),
          FoodFlashcardGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

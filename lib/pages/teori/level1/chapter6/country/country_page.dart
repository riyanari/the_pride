import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';

import 'tabs/country_pengertian_tab.dart';
import 'tabs/country_penjelasan_tab.dart';
import 'tabs/country_vocabulary_tab.dart';
import 'tabs/country_game_match.dart';
import 'tabs/country_game_mcq.dart';
import 'tabs/country_game_gapfill.dart';
import 'tabs/country_game_flashcards.dart';

class CountryPage extends StatelessWidget {
  const CountryPage({super.key});

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
      appBar: const CustomAppBar('Countries', iconSize: 16),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          CountryPengertianTab(),
          CountryPenjelasanTab(),
          CountryVocabularyTab(),
          CountryFlashcardGame(),
          CountryMatchGame(),
          CountryMCQGame(),
          CountryGapFillGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

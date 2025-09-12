import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';

import 'tabs/mapdir_pengertian_tab.dart';
import 'tabs/mapdir_penjelasan_tab.dart';
import 'tabs/mapdir_vocabulary_tab.dart';
import 'tabs/mapdir_game_match.dart';
import 'tabs/mapdir_game_mcq.dart';
import 'tabs/mapdir_game_gapfill.dart';
import 'tabs/mapdir_game_flashcards.dart';

class MapDirectionPage extends StatelessWidget {
  const MapDirectionPage({super.key});

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
      appBar: const CustomAppBar('Map & Directions', iconSize: 16),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          MapDirPengertianTab(),
          MapDirPenjelasanTab(),
          MapDirVocabularyTab(),
          MapDirFlashcardGame(),
          MapDirMatchGame(),
          MapDirMCQGame(),
          MapDirGapFillGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';

import 'tabs/auxv_pengertian_tab.dart';
import 'tabs/auxv_penjelasan_tab.dart';
import 'tabs/auxv_vocabulary_tab.dart';
import 'tabs/auxv_game_flashcards.dart';
import 'tabs/auxv_game_match.dart';
import 'tabs/auxv_game_mcq.dart';
import 'tabs/auxv_game_gapfill.dart';

class BasicAuxVPage extends StatelessWidget {
  const BasicAuxVPage({super.key});

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
      appBar: const CustomAppBar('Basic Auxiliary Verbs', iconSize: 16),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          AuxVPengertianTab(),
          AuxVPenjelasanTab(),
          AuxVVocabularyTab(),
          AuxVFlashcardGame(),
          AuxVMatchGame(),
          AuxVMCQGame(),
          AuxVGapFillGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

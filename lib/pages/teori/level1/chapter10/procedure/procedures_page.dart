import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';
import 'package:the_pride/pages/teori/level1/chapter10/procedure/tabs/proc_game_flashcards.dart';
import 'package:the_pride/pages/teori/level1/chapter10/procedure/tabs/proc_game_gapfill.dart';
import 'package:the_pride/pages/teori/level1/chapter10/procedure/tabs/proc_game_match.dart';
import 'package:the_pride/pages/teori/level1/chapter10/procedure/tabs/proc_game_mcq.dart';
import 'package:the_pride/pages/teori/level1/chapter10/procedure/tabs/proc_game_ordering.dart';
import 'package:the_pride/pages/teori/level1/chapter10/procedure/tabs/proc_pengertian_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter10/procedure/tabs/proc_penjelasan_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter10/procedure/tabs/proc_vocabulary_tab.dart';

class ProceduresPage extends StatelessWidget {
  const ProceduresPage({super.key});

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
      'Game: Ordering',
    ];

    return Scaffold(
      appBar: const CustomAppBar('Procedures & Instructions', iconSize: 16),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          ProcPengertianTab(),
          ProcPenjelasanTab(),
          ProcVocabularyTab(),
          ProcFlashcardGame(),
          ProcMatchGame(),
          ProcMCQGame(),
          ProcGapFillGame(),
          ProcOrderingGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';
import 'package:the_pride/pages/teori/level1/chapter7/complain_apologize/tabs/ca_game_flashcards.dart';
import 'package:the_pride/pages/teori/level1/chapter7/complain_apologize/tabs/ca_game_gapfill.dart';
import 'package:the_pride/pages/teori/level1/chapter7/complain_apologize/tabs/ca_game_match.dart';
import 'package:the_pride/pages/teori/level1/chapter7/complain_apologize/tabs/ca_game_mcq.dart';
import 'package:the_pride/pages/teori/level1/chapter7/complain_apologize/tabs/ca_pengertian_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter7/complain_apologize/tabs/ca_penjelasan_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter7/complain_apologize/tabs/ca_vocabulary_tab.dart';


class ComplainingApologizingPage extends StatelessWidget {
  const ComplainingApologizingPage({super.key});

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
      appBar: const CustomAppBar('Complaining & Apologizing', iconSize: 16),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          CompApoPengertianTab(),
          CompApoPenjelasanTab(),
          CompApoVocabularyTab(),
          CompApoFlashcardGame(),
          CompApoMatchGame(),
          CompApoMCQGame(),
          CompApoGapFillGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';

import 'tabs/sugreq_pengertian_tab.dart';
import 'tabs/sugreq_penjelasan_tab.dart';
import 'tabs/sugreq_vocabulary_tab.dart';
import 'tabs/sugreq_game_flashcards.dart';
import 'tabs/sugreq_game_match.dart';
import 'tabs/sugreq_game_mcq.dart';
import 'tabs/sugreq_game_gapfill.dart';

class SuggestionRequestPage extends StatelessWidget {
  const SuggestionRequestPage({super.key});

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
      appBar: const CustomAppBar('Suggestion & Request', iconSize: 16),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          SugReqPengertianTab(),
          SugReqPenjelasanTab(),
          SugReqVocabularyTab(),
          SugReqFlashcardGame(),
          SugReqMatchGame(),
          SugReqMCQGame(),
          SugReqGapFillGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

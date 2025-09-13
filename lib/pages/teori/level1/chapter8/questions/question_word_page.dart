import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';

import 'tabs/question_pengertian_tab.dart';
import 'tabs/question_penjelasan_tab.dart';
import 'tabs/question_vocabulary_tab.dart';
import 'tabs/question_game_flashcards.dart';
import 'tabs/question_game_match.dart';
import 'tabs/question_game_mcq.dart';
import 'tabs/question_game_gapfill.dart';

class QuestionWordPage extends StatelessWidget {
  const QuestionWordPage({super.key});

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
      appBar: const CustomAppBar('Question Words', iconSize: 16),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          QuestionPengertianTab(),
          QuestionPenjelasanTab(),
          QuestionVocabularyTab(),
          QuestionFlashcardGame(),
          QuestionMatchGame(),
          QuestionMCQGame(),
          QuestionGapFillGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

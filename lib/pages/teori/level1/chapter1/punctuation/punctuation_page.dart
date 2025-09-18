import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';
import 'package:the_pride/pages/teori/level1/chapter1/punctuation/puntuation2_tab.dart';

// materi
import 'punctuation1_tab.dart';

// games
import 'tabs/punc_game_mcq.dart';
import 'tabs/punc_game_gapfill.dart';
import 'tabs/punc_game_match.dart';

class PunctuationPage extends StatefulWidget {
  const PunctuationPage({super.key});

  @override
  State<PunctuationPage> createState() => _PunctuationPageState();
}

class _PunctuationPageState extends State<PunctuationPage> {
  @override
  Widget build(BuildContext context) {
    final titles = [
      'Punctuation 1',
      'Punctuation 2',
      'Game: MCQ',
      'Game: Gap Fill',
      'Game: Match',
    ];

    return Scaffold(
      appBar: const CustomAppBar("Punctuation", iconSize: 16.0),
      body: CustomPageView(
        pageTitles: titles,
        pages: const [
          PunctuationSymbolQuizTab(),
          Punctuation1Tab(),
          PuncMCQGame(),
          PuncGapFillGame(),
          PuncMatchGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

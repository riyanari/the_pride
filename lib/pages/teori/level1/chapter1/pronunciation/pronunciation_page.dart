import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';
import 'package:the_pride/pages/teori/level1/chapter1/pronunciation/minimal_pairs_game_page.dart';
import 'package:the_pride/pages/teori/level1/chapter1/pronunciation/shadowing_practice_page.dart';
import 'package:the_pride/pages/teori/level1/chapter1/pronunciation/syllable_count_game_page.dart';
import 'package:the_pride/pages/teori/level1/chapter1/pronunciation/word_stress_game_page.dart';
import 'package:the_pride/utils/audio_services.dart';

import 'consonant_page.dart';
import 'orthography_tab.dart';
import 'pronunciation_test.dart';
import 'sound_lessons_tab.dart';
import 'vowel_page.dart';
import 'word_connection_tab.dart';

class PronunciationPage extends StatefulWidget {
  const PronunciationPage({super.key});

  @override
  State<PronunciationPage> createState() => _PronunciationPageState();
}

class _PronunciationPageState extends State<PronunciationPage> {
  final AudioService _audioService = AudioService();
  final List<String> _pageTitles = [
    'English Vowels',
    'English Consonants',
    'Orthography Test',
    'pronun Test',
    'Word Connection',
    'Sound Lessons',
    'Shadowing',
    'Minimal Paris',
    'Syllable Count',
    'Word Stress',
    // 'Pronunciation Practice',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Pronunciation", iconSize: 16.0),
      body: CustomPageView(
        pageTitles: _pageTitles,
        pages: [
          VowelsTab(
            audioService: _audioService,
            title: _pageTitles[0],
          ),
          ConsonantTab(
              audioService: _audioService,
            title: _pageTitles[1],
          ),
          OrthographyTab(),
          PronunciationTestPage(),
          WordConnectionTab(
            audioService: _audioService,
            title: _pageTitles[4],
          ),
          SoundLessonsTab(
            audioService: _audioService,
            title: _pageTitles[5],
          ),
          ShadowingPracticePage(audioService: _audioService),
          MinimalPairsGamePage(audioService: _audioService),
          SyllableCountGamePage(),
          WordStressGamePage()
          // PronunPracticeTabs(
          //   audioService: _audioService,
          //   title: _pageTitles[7],
          // ),
        ],
        onFinish: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

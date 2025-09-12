import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';
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
    'Pronunciation Practice',
  ];

  Widget _buildPracticePage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 64, color: Colors.green[400]),
            const SizedBox(height: 16),
            Text(
              'Practice Area',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Interactive pronunciation practice coming soon',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

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
          _buildPracticePage(),
        ],
        onFinish: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

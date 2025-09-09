import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/components/list_chapter.dart';

class Level3Page extends StatelessWidget {
  const Level3Page({super.key});

  List<Map<String, dynamic>> dataLevel1() {
    return [
      {
        'level': 'Level 1',
        'name': 'Page (The Beginner)',
        'jargon': 'Every knight starts as a Page, learning the first steps of honor and words.',
        'kd_level': 'HG5LK',
      },
    ];
  }

  List<Map<String, dynamic>> materiLevel1() {
    return [
      {
        'chapter': 'Chapter 1',
        'judul_chapter': 'Getting Started with English',
        'sub_chapters': [
          'The Alphabet in English',
          'Pronunciation',
          'Punctuation',
        ],
      },
      {
        'chapter': 'Chapter 2',
        'judul_chapter': 'Everyday Greetings & Expressions',
        'sub_chapters': [
          'Greeting',
          'Giving and Responding to Compliment',
        ],
      },
      {
        'chapter': 'Chapter 3',
        'judul_chapter': 'My World – Family & Friends',
        'sub_chapters': [
          'Family',
          'Job and Profession',
          'Hobby',
        ],
      },
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListChapter(materi: materiLevel1(), dataLevel: dataLevel1(),)
        ],
      ),
    );
  }
}

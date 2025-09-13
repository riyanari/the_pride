import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/components/list_chapter.dart';
import 'package:the_pride/theme/theme.dart';

class Level1Page extends StatelessWidget {
  const Level1Page({super.key});

  List<Map<String, dynamic>> dataLevel1() {
    return [
      {
        'level': 'Level 1',
        'name': 'Page (The Beginner)',
        'jargon': 'Every knight starts as a Page, learning the first steps of honor and words.',
        'kd_level': 'HG5LK',
        'poin': '2530',
      },
    ];
  }

  List<Map<String, dynamic>> materiLevel1() {
    return [
      {
        'chapter': 'Chapter 1',
        'judul_chapter': 'Getting Started with English',
        'sub_chapters': [
          {
            'title': 'The Alphabet in English',
            'route': '/1/chapter1/alphabet',
          },
          {
            'title': 'Pronunciation',
            'route': '/1/chapter1/pronunciation',
          },
          {
            'title': 'Punctuation',
            'route': '/1/chapter1/punctuation',
          },
        ],
      },
      {
        'chapter': 'Chapter 2',
        'judul_chapter': 'Everyday Greetings & Expressions',
        'sub_chapters': [
          {
            'title': 'Greeting',
            'route': '/1/chapter2/greeting',
          },
          {
            'title': 'Giving and Responding to Compliment',
            'route': '/1/chapter2/compliment',
          },
        ],
      },
      {
        'chapter': 'Chapter 3',
        'judul_chapter': 'My World – Family & Friends',
        'sub_chapters': [
          {
            'title': 'Family',
            'route': '/1/chapter3/family',
          },
          {
            'title': 'Job and Profession',
            'route': '/1/chapter3/job',
          },
          {
            'title': 'Hobby',
            'route': '/1/chapter3/hobby',
          },
        ],
      },
      {
        'chapter': 'Chapter 4',
        'judul_chapter': 'Numbers, Time & Everyday Life',
        'sub_chapters': [
          {
            'title': 'Number',
            'route': '/1/chapter4/number',
          },
          {
            'title': 'Time',
            'route': '/1/chapter4/time',
          },
        ],
      },
      {
        'chapter': 'Chapter 5',
        'judul_chapter': 'Food, Color & Things Around Me',
        'sub_chapters': [
          {
            'title': 'Food',
            'route': '/1/chapter5/food',
          },
          {
            'title': 'Color',
            'route': '/1/chapter5/color',
          },
        ],
      },
      {
        'chapter': 'Chapter 6',
        'judul_chapter': 'Exploring the World',
        'sub_chapters': [
          {
            'title': 'Country',
            'route': '/1/chapter6/country',
          },
          {
            'title': 'Map and Direction',
            'route': '/1/chapter6/map',
          },
        ],
      },
      {
        'chapter': 'Chapter 7',
        'judul_chapter': 'Body Language & Social Interaction',
        'sub_chapters': [
          {
            'title': 'Gesture',
            'route': '/1/chapter7/gesture',
          },
          {
            'title': 'Complaining and Apologizing',
            'route': '/1/chapter7/complain',
          },
        ],
      },
      {
        'chapter': 'Chapter 8',
        'judul_chapter': 'Asking Questions & Getting Answers',
        'sub_chapters': [
          {
            'title': 'Question Word',
            'route': '/1/chapter8/question',
          },
          {
            'title': 'Basic Auxiliary Verb',
            'route': '/1/chapter8/complain',
          },
        ],
      },
      {
        'chapter': 'Chapter 9',
        'judul_chapter': 'Making Requests & Suggestions',
        'sub_chapters': [
          {
            'title': 'Suggestion and Request',
            'route': '/1/chapter9/suggestion',
          },
        ],
      },
      {
        'chapter': 'Chapter 10',
        'judul_chapter': 'Procedures & Instructions',
        'sub_chapters': [
          {
            'title': 'Procedure',
            'route': '/1/chapter10/procedure',
          },
        ],
      },
    ];
  }

  Widget header() {
    var levelData = dataLevel1()[0];  // Memanggil data dengan benar
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kBoxGreyColor,
                    ),
                    child: Image.asset('assets/ic_back.png'),
                  ),
                  SizedBox(width: 8),
                  Text(
                    levelData['level'],  // Menampilkan level
                    style: primaryTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset('assets/ic_code.png', height: 18),
                  SizedBox(width: 4),
                  Text(
                    levelData['kd_level'],  // Menampilkan kode level
                    style: primaryTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: semiBold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Image.asset('assets/ic_coins_black.png', height: 18),
                  SizedBox(width: 4),
                  Text(
                    levelData['poin'],  // Menampilkan poin
                    style: primaryTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            levelData['name'],  // Menampilkan nama level
            style: primaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            levelData['jargon'],  // Menampilkan jargon
            style: primaryTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kBackgroundPrimaryColor,
      body: SafeArea(
        child: ListChapter(materi: materiLevel1(), dataLevel: dataLevel1(),),
      ),
    );
  }
}

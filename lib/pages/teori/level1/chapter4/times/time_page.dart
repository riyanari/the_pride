import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/tabs/game_gapfill.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/tabs/game_match.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/tabs/game_mcq.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/tabs/game_ordering.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/tabs/pengertian_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/tabs/penjelasan_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/tabs/vocab_tab.dart';

class TimePage extends StatelessWidget {
  const TimePage({super.key});

  @override
  Widget build(BuildContext context) {
    const pageTitles = [
      'Pengertian',
      'Penjelasan',
      'Kosakata',
      'Game: Quick Match',
      'Game: Best Choice',
      'Game: Gap Fill',
      'Game: Ordering',
    ];

    return Scaffold(
      appBar: CustomAppBar('Time', iconSize: 16.0),
      body: CustomPageView(
        pageTitles: pageTitles,
        pages: const [
          TimePengertianTab(),
          TimePenjelasanTab(),
          TimeVocabTab(),
          TimeMatchGame(),
          TimeMcqGame(),
          TimeGapFillGame(),
          TimeOrderingGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

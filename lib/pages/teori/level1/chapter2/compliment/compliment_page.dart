import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';
import 'package:the_pride/pages/teori/level1/chapter2/compliment/tabs/compliments_game_builder.dart';
import 'package:the_pride/pages/teori/level1/chapter2/compliment/tabs/compliments_game_mcq.dart';
import 'package:the_pride/pages/teori/level1/chapter2/compliment/tabs/pengertian_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter2/compliment/tabs/penjelasan_tab.dart';
import 'package:the_pride/pages/teori/level1/chapter2/compliment/tabs/quick_match_game.dart';
// ⬇️ Tambahkan ini
import 'package:the_pride/pages/teori/level1/chapter2/compliment/tabs/compliments_game_gapfill.dart';

class ComplimentsPage extends StatelessWidget {
  const ComplimentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageTitles = const [
      'Pengertian',
      'Penjelasan',
      'Game: Quick Match',
      'Game: Best Response',
      'Game: Gap Fill',      // ⬅️ baru
      'Game: Builder',
    ];

    return Scaffold(
      appBar: CustomAppBar('Compliments', iconSize: 16.0),
      body: CustomPageView(
        pageTitles: pageTitles,
        pages: const [
          PengertianTab(),
          PenjelasanTab(),
          QuickMatchGame(),
          McqGame(),
          ComplimentGapFillGame(), // ⬅️ baru
          BuildComplimentGame(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

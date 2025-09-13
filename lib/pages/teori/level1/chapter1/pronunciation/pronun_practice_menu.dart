import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

import 'minimal_pairs_game_page.dart';
import 'shadowing_practice_page.dart';
import 'syllable_count_game_page.dart';
import 'word_stress_game_page.dart';

class PronunPracticeMenu extends StatelessWidget {
  final AudioService audioService;
  final String title;
  const PronunPracticeMenu({
    super.key,
    required this.audioService,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem(
        icon: Icons.record_voice_over,
        title: 'Shadowing',
        subtitle: 'Listen → imitate → record & compare',
        builder: (_) => ShadowingPracticePage(audioService: audioService),
      ),
      _MenuItem(
        icon: Icons.hearing,
        title: 'Minimal Pairs',
        subtitle: 'Listen & choose the word you hear',
        builder: (_) => MinimalPairsGamePage(audioService: audioService),
      ),
      _MenuItem(
        icon: Icons.tag,
        title: 'Syllable Count',
        subtitle: 'Pick the number of syllables',
        builder: (_) => SyllableCountGamePage(),
      ),
      _MenuItem(
        icon: Icons.grading,
        title: 'Word Stress',
        subtitle: 'Tap the stressed syllable',
        builder: (_) => WordStressGamePage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final it = items[i];
          return InkWell(
            onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: it.builder),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.withValues(alpha:0.18)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 6, offset: const Offset(0,2))],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo.withValues(alpha:0.1),
                  child: Icon(it.icon, color: Colors.indigo),
                ),
                title: Text(it.title, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                subtitle: Text(it.subtitle, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final WidgetBuilder builder;
  _MenuItem({required this.icon, required this.title, required this.subtitle, required this.builder});
}

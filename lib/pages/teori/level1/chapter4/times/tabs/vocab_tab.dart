import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/time_shared.dart';
import 'package:the_pride/utils/audio_services.dart';

class TimeVocabTab extends StatelessWidget {
  const TimeVocabTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final cats = kTimeCategories;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          for (final c in cats) ...[
            sectionTitle(_label(c), _color(c)),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: byCat(c).length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, mainAxisExtent: 150,
              ),
              itemBuilder: (_, i) => vocabTile(byCat(c)[i], color: _color(c), audio: audio),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  String _label(String c) => switch (c) {
    C_CLOCK => 'Clock Phrases',
    C_PREP => 'Prepositions of Time',
    C_TOD => 'Time of Day',
    C_FREQ => 'Frequency Adverbs',
    C_DURATION => 'Duration Units',
    _ => c,
  };

  Color _color(String c) => switch (c) {
    C_CLOCK => Colors.teal,
    C_PREP => Colors.orange,
    C_TOD => Colors.green,
    C_FREQ => Colors.purple,
    C_DURATION => Colors.brown,
    _ => Colors.grey,
  };
}

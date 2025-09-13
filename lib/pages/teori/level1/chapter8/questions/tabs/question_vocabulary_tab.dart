import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../question_shared.dart';

class QuestionVocabularyTab extends StatefulWidget {
  const QuestionVocabularyTab({super.key});

  @override
  State<QuestionVocabularyTab> createState() => _QuestionVocabularyTabState();
}

class _QuestionVocabularyTabState extends State<QuestionVocabularyTab> {
  String _cat = 'all';

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final items = _cat == 'all' ? kQWVocab : byCat(_cat);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Pilih Kategori', Colors.indigo),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: -6,
            children: [
              for (final c in ['all', ...kQWCategories])
                ChoiceChip(
                  label: Text(c),
                  selected: _cat == c,
                  onSelected: (_) => setState(() => _cat = c),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Masonry-ish wrap (tidak kaku seperti grid fixed ratio)
          Wrap(
            spacing: 10, runSpacing: 10,
            children: [
              for (final v in items)
                SizedBox(
                  width: MediaQuery.of(context).size.width/2 - 28, // 2 kolom responsif
                  child: qwTile(v, color: Colors.teal, audio: audio),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

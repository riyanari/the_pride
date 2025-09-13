import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../auxv_shared.dart';

class AuxVVocabularyTab extends StatefulWidget {
  const AuxVVocabularyTab({super.key});

  @override
  State<AuxVVocabularyTab> createState() => _AuxVVocabularyTabState();
}

class _AuxVVocabularyTabState extends State<AuxVVocabularyTab> {
  String _cat = 'all';

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final items = _cat == 'all' ? kAuxVocab : byCat(_cat);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Pilih Kategori', Colors.indigo),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: -6,
            children: [
              for (final c in ['all', ...kAuxCategories])
                ChoiceChip(
                  label: Text(c),
                  selected: _cat == c,
                  onSelected: (_) => setState(() => _cat = c),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10, runSpacing: 10,
            children: [
              for (final v in items)
                SizedBox(
                  width: MediaQuery.of(context).size.width/2 - 28,
                  child: auxTile(v, color: Colors.teal, audio: audio),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../compapo_shared.dart';

class CompApoVocabularyTab extends StatefulWidget {
  const CompApoVocabularyTab({super.key});

  @override
  State<CompApoVocabularyTab> createState() => _CompApoVocabularyTabState();
}

class _CompApoVocabularyTabState extends State<CompApoVocabularyTab> {
  String _cat = 'all';

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final items = _cat == 'all' ? kCompApoVocab : byCat(_cat);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          sectionTitle('Pilih Kategori', Colors.indigo),
          const SizedBox(height: 8),
          // Wrap(
          //   spacing: 8, runSpacing: -6,
          //   children: [
          //     for (final c in ['all', ...kCompApoCategories])
          //       ChoiceChip(
          //         label: Text(c),
          //         selected: _cat == c,
          //         onSelected: (_) => setState(() => _cat = c),
          //       ),
          //   ],
          // ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in kCompApoCategories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _cat == c,
                      onSelected: (_) => setState(() => _cat = c),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (_, i) => vocabTile(items[i], audio: audio),
            ),
          ),
        ],
      ),
    );
  }
}

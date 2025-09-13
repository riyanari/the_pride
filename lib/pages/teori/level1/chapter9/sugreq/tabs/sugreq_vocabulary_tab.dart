import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../sugreq_shared.dart';

class SugReqVocabularyTab extends StatefulWidget {
  const SugReqVocabularyTab({super.key});
  @override
  State<SugReqVocabularyTab> createState() => _SugReqVocabularyTabState();
}

class _SugReqVocabularyTabState extends State<SugReqVocabularyTab> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final items = _filter == 'all' ? kSugReqVocab : byType(_filter);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Pilih Kategori', Colors.indigo),
          const SizedBox(height: 8),
          // Wrap(
          //   spacing: 8, runSpacing: -6,
          //   children: [
          //     for (final c in ['all', ...kSugReqCategories])
          //       ChoiceChip(
          //         label: Text(c),
          //         selected: _filter == c,
          //         onSelected: (_) => setState(() => _filter = c),
          //       ),
          //   ],
          // ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in kSugReqCategories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _filter == c,
                      onSelected: (_) => setState(() => _filter = c),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => vocabTile(items[i], color: Colors.teal, audio: audio),
          ),
        ],
      ),
    );
  }
}

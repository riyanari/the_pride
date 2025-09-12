import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../map_direction_shared.dart';

class MapDirVocabularyTab extends StatefulWidget {
  const MapDirVocabularyTab({super.key});

  @override
  State<MapDirVocabularyTab> createState() => _MapDirVocabularyTabState();
}

class _MapDirVocabularyTabState extends State<MapDirVocabularyTab> {
  String _cat = C_VERB;

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final items = byCat(_cat);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Kategori', Colors.indigo),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in kMapDirCategories)
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
          // Wrap(
          //   spacing: 8, runSpacing: 8,
          //   children: [
          //     for (final c in kMapDirCategories)
          //       ChoiceChip(
          //         label: Text(c.split('_').first.toUpperCase()),
          //         selected: _cat == c,
          //         onSelected: (_) => setState(() => _cat = c),
          //       ),
          //   ],
          // ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                // mainAxisExtent: 150,
              ),
              itemBuilder: (_, i) => vocabTile(items[i], audio: audio),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../color_shared.dart';

class ColorVocabularyTab extends StatefulWidget {
  const ColorVocabularyTab({super.key});
  @override
  State<ColorVocabularyTab> createState() => _ColorVocabularyTabState();
}

class _ColorVocabularyTabState extends State<ColorVocabularyTab> {
  String _cat = C_BASIC;

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
                for (final c in kColorCategories)
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
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1,
              ),
              itemBuilder: (_, i) => colorTile(items[i], audio: audio),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../food_shared.dart';

class FoodVocabularyTab extends StatefulWidget {
  const FoodVocabularyTab({super.key});
  @override
  State<FoodVocabularyTab> createState() => _FoodVocabularyTabState();
}

class _FoodVocabularyTabState extends State<FoodVocabularyTab> {
  String _cat = C_STAPLES;

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
                for (final c in kFoodCategories)
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
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.2,
              ),
              itemBuilder: (_, i) => vocabTile(items[i], audio: audio),
            ),
          ),
        ],
      ),
    );
  }
}

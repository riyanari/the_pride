import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../gesture_shared.dart';

class GestureVocabularyTab extends StatefulWidget {
  const GestureVocabularyTab({super.key});

  @override
  State<GestureVocabularyTab> createState() => _GestureVocabularyTabState();
}

class _GestureVocabularyTabState extends State<GestureVocabularyTab> {
  String _cat = 'all';

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final items = _cat == 'all' ? kGestureVocab : byCat(_cat);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Pilih Kategori', Colors.indigo),
          const SizedBox(height: 8),
          // Wrap(
          //   spacing: 8, runSpacing: -6,
          //   children: [
          //     for (final c in ['all', ...kGestureCategories])
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
                for (final c in kGestureCategories)
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.66,
            ),
            itemBuilder: (_, i) => gestureTile(items[i], color: Colors.teal, audio: audio),
          ),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: (items.length / 2).ceil(),
          //   itemBuilder: (_, row) {
          //     final i = row * 2;
          //     final left  = items[i];
          //     final right = i + 1 < items.length ? items[i + 1] : null;
          //     return Padding(
          //       padding: const EdgeInsets.only(bottom: 10),
          //       child: Row(
          //         children: [
          //           Expanded(child: gestureTile(left, color: Colors.teal, audio: audio)),
          //           const SizedBox(width: 10),
          //           Expanded(child: right != null
          //               ? gestureTile(right, color: Colors.teal, audio: audio)
          //               : const SizedBox()),
          //         ],
          //       ),
          //     );
          //   },
          // )

        ],
      ),
    );
  }
}

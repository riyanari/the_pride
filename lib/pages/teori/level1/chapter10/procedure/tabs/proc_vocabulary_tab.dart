import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../procedures_shared.dart';

class ProcVocabularyTab extends StatefulWidget {
  const ProcVocabularyTab({super.key});
  @override
  State<ProcVocabularyTab> createState() => _ProcVocabularyTabState();
}

class _ProcVocabularyTabState extends State<ProcVocabularyTab> {
  String _cat = 'all';

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final items = _cat == 'all' ? kProcVocab : byCat(_cat);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Pilih Kategori', Colors.indigo),
          const SizedBox(height: 8),

          // ⬇️ Ganti Wrap -> SingleChildScrollView horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // "all" duluan
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('all'),
                    selected: _cat == 'all',
                    onSelected: (_) => setState(() => _cat = 'all'),
                  ),
                ),
                // lalu kategori lain
                for (final c in kProcCategories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
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

          // GridView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: items.length,
          // //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          // //     maxCrossAxisExtent: 320,
          // //     mainAxisSpacing: 10,
          // //     crossAxisSpacing: 10,
          // //     mainAxisExtent: 130,
          // //   ),
          // //   itemBuilder: (_, i) => procTile(items[i], color: Colors.teal, audio: audio),
          // // ),
          Wrap(
            spacing: 10, runSpacing: 10,
            children: [
              for (final v in items)
                SizedBox(
                  width: MediaQuery.of(context).size.width/2 - 28,
                  child: procTile(v, color: Colors.teal, audio: audio),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

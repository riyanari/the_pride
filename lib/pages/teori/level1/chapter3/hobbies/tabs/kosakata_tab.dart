import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import 'package:the_pride/pages/teori/level1/chapter3/hobbies/hobbies_shared.dart';

class HobbiesKosakataTab extends StatefulWidget {
  const HobbiesKosakataTab({super.key});

  @override
  State<HobbiesKosakataTab> createState() => _HobbiesKosakataTabState();
}

class _HobbiesKosakataTabState extends State<HobbiesKosakataTab> {
  final audio = AudioService();
  String _query = '';
  String _category = 'all';

  @override
  Widget build(BuildContext context) {
    final cats = ['all', ...kHobbyCategories];
    final list = kHobbyVocab.where((v) {
      final byCat = _category == 'all' || v.category == _category;
      final q = _query.trim().toLowerCase();
      final byText = q.isEmpty || v.term.toLowerCase().contains(q) || v.indo.toLowerCase().contains(q);
      return byCat && byText;
    }).toList();

    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 360;
    final extent = isNarrow ? 210.0 : 230.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Kosakata Hobi', Colors.teal),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Cari kata (EN/ID)...'),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in cats)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _category == c,
                      onSelected: (_) => setState(() => _category = c),
                      selectedColor: Colors.teal.withValues(alpha:0.2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isNarrow ? 1 : 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: extent,
            ),
            itemCount: list.length,
            itemBuilder: (_, i) => vocabTile(list[i], audio: audio),
          ),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.volume_up, text: 'Tap speaker untuk listening & pronunciation. Isi path gambar jika tersedia.'),
        ],
      ),
    );
  }
}

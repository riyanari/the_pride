import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../food_shared.dart';

class FoodPengertianTab extends StatelessWidget {
  const FoodPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final tips = const [
      Tip('Definisi', 'Topik “Food & Drinks” meliputi nama makanan/minuman, rasa, cara memasak, serta ungkapan memesan/menawarkan.'),
      Tip('Tujuan', 'Mampu mendeskripsikan makanan, menyatakan suka/tidak suka, memilih menu, dan berbasa-basi di restoran.'),
      Tip('Budaya', 'Sebut alergi/pantangan dengan sopan. Gunakan please/thank you saat memesan.'),
    ];

    final examples = const [
      FoodVocab(term: 'I like spicy food.', indo: 'Saya suka makanan pedas.', category: C_TASTE, ipa: '/aɪ laɪk ˈspaɪsi fuːd/'),
      FoodVocab(term: 'Could I have a glass of water, please?', indo: 'Boleh minta segelas air, tolong?', category: C_DRINKS),
      FoodVocab(term: 'This soup is too salty.', indo: 'Sup ini terlalu asin.', category: C_TASTE),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) tipCard(t, Colors.blue),
          const SizedBox(height: 16),
          sectionTitle('Contoh Ungkapan', Colors.teal),
          const SizedBox(height: 8),
          for (final v in examples) vocabTile(v, color: Colors.teal, audio: audio),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.lightbulb_outline, text: 'Gunakan ungkapan sopan: "Could I have…?", "I\'d like…", "Would you like…?"'),
        ],
      ),
    );
  }
}

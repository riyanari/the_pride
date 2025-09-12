import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter3/hobbies/hobbies_shared.dart';

class HobbiesPenjelasanTab extends StatelessWidget {
  const HobbiesPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      Tip('Rumus / Pola Umum',
          '• like/love/enjoy + V-ing: “I enjoy cooking.”\n'
              '• be into + noun/V-ing: “I am into photography.”\n'
              '• spend time + V-ing: “She spends time reading.”\n'
              '• prefer + noun/V-ing: “They prefer hiking to cycling.”'),
      Tip('Menanyakan Hobi',
          '• What do you do for fun?\n• What are your hobbies?\n• What are you into?'),
      Tip('Menjawab & Menjelas',
          '• I love ... because ...\n• I got into ... during ...\n• I usually ... on weekends.'),
      Tip('Kohesi & Detail',
          'Tambah detail agar natural: frekuensi, tempat, alat, alasan (because, since, so).'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Penjelasan & Rumus', Colors.purple),
          const SizedBox(height: 8),
          for (final t in items) tipCard(t, Colors.purple),
          const SizedBox(height: 16),
          infoBadge(icon: Icons.tips_and_updates,
              text: 'Gunakan adverb frekuensi: always, often, sometimes, rarely, never — untuk memperjelas kebiasaan.'),
        ],
      ),
    );
  }
}

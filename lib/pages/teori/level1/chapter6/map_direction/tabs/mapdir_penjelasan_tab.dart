import 'package:flutter/material.dart';
import '../map_direction_shared.dart';

class MapDirPenjelasanTab extends StatelessWidget {
  const MapDirPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final points = const [
      Tip('Bertanya Arah', '“How do I get to …?”, “Could you tell me the way to …?” + [tempat].'),
      Tip('Memberi Arah', 'Mulai dari lokasi saat ini → langkah-langkah: go straight, turn left/right, take the second left, cross the street.'),
      Tip('Preposisi Tempat', 'next to, between (A and B), across from, in front of, behind, on the corner of.'),
      Tip('Penanda Jalan', 'block (jarak antar persimpangan), intersection, traffic light, crosswalk, street/avenue.'),
      Tip('Sopan Santun', 'Awali dengan “Excuse me” ketika bertanya, dan ucapkan “Thank you” setelah selesai.'),
    ];

    final patterns = const [
      Tip('Rumus 1', 'Go straight for [jumlah] blocks, then turn [left/right] at the [landmark].'),
      Tip('Rumus 2', 'It is [next to / across from / between A and B].'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Poin Penting', Colors.purple),
          const SizedBox(height: 8),
          for (final t in points) tipCard(t, Colors.purple),
          const SizedBox(height: 16),
          sectionTitle('Rumus / Pola', Colors.brown),
          const SizedBox(height: 8),
          for (final t in patterns) tipCard(t, Colors.brown),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.tips_and_updates, text: 'Sebutkan tujuan dulu, lalu langkah-langkah rute secara urut dan jelas.'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../map_direction_shared.dart';

class MapDirPengertianTab extends StatelessWidget {
  const MapDirPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    final tips = const [
      Tip('Definisi', 'Topik “Map & Directions” mencakup kosakata untuk bertanya/ memberi arah, preposisi tempat, dan nama lokasi umum.'),
      Tip('Tujuan', 'Agar bisa menanyakan lokasi, memahami petunjuk jalan, dan menggambarkan rute secara jelas.'),
      Tip('Pola Umum', 'Bertanya: “How do I get to …?”, “Where is the …?”; Memberi arahan: go straight, turn left/right, across from, next to.'),
    ];

    final examples = const [
      MapDirVocab(term:'How do I get to the station?', indo:'Bagaimana saya menuju stasiun?', category:C_PHRASE),
      MapDirVocab(term:'Go straight and turn right at the bank.', indo:'Jalan lurus lalu belok kanan di bank.', category:C_VERB),
      MapDirVocab(term:'The café is across from the library.', indo:'Kafe berada di seberang perpustakaan.', category:C_PREP),
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
          infoBadge(icon: Icons.map_outlined, text: 'Gunakan penanda rute: blocks, intersection, traffic light, corner untuk memperjelas posisi.'),
        ],
      ),
    );
  }
}

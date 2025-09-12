import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../color_shared.dart';

class ColorPengertianTab extends StatelessWidget {
  const ColorPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    final tips = const [
      Tip('Definisi', 'Topik “Colors” meliputi nama warna dasar, warna turunan, kata sifat pendukung (light/dark/bright/pale), dan pola (striped, dotted, plaid).'),
      Tip('Tujuan', 'Mendeskripsikan objek berdasarkan warna, mengekspresikan preferensi, dan memahami instruksi yang melibatkan warna.'),
      Tip('Urutan Sifat', 'Dalam frasa: size → color → noun. Contoh: "a small red bag".'),
    ];

    final examples = const [
      ColorVocab(term:'I like bright colors.', indo:'Saya suka warna-warna cerah.', category:C_ADJ, ipa:'/aɪ laɪk braɪt ˈkʌləz/'),
      ColorVocab(term:'She wore a striped dress.', indo:'Dia memakai gaun bergaris.', category:C_PATTERN),
      ColorVocab(term:'The car is dark blue.', indo:'Mobilnya biru tua.', category:C_ADJ),
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
          for (final v in examples) colorTile(v, color: Colors.teal, audio: audio),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.lightbulb_outline, text: 'Gunakan "light/dark/bright/pale" sebelum warna: light green, dark red.'),
        ],
      ),
    );
  }
}

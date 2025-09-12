import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';

import 'package:the_pride/pages/teori/level1/chapter4/times/time_shared.dart';



class TimePengertianTab extends StatelessWidget {
  const TimePengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final tips = const [
      Tip('Definisi', 'Topik “Time” mencakup cara menyebut jam (telling the time), preposisi waktu (at/in/on), dan ekspresi frekuensi/durasi.'),
      Tip('Tujuan', 'Supaya bisa menanyakan/menjawab jam, jadwal, dan kebiasaan harian dengan natural.'),
      Tip('12h vs 24h', 'Bahasa Inggris percakapan umum memakai 12 jam + AM/PM. 24 jam lazim pada jadwal resmi.'),
      Tip('Quarter/Half', '“a quarter past/to” = 15 menit; “half past” = 30 menit.'),
    ];

    final examples = const [
      TimeVocab(term: "It's a quarter past seven.", indo: 'Jam tujuh lewat lima belas.', category: C_CLOCK, ipa: '/ɪts ə ˈkwɔːtə pɑːst ˈsevən/'),
      TimeVocab(term: "We meet at 6 PM on Monday.", indo: 'Kita bertemu jam 6 sore pada hari Senin.', category: C_PREP),
      TimeVocab(term: "I usually wake up at dawn.", indo: 'Saya biasanya bangun saat fajar.', category: C_TOD),
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
          infoBadge(icon: Icons.lightbulb_outline, text: 'Ucapkan jam dengan pola: [minute + past/to + hour]. Contoh: 20 past five, 10 to nine.'),
        ],
      ),
    );
  }
}

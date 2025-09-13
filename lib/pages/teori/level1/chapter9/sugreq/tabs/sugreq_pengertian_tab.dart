import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../sugreq_shared.dart';

class SugReqPengertianTab extends StatelessWidget {
  const SugReqPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final tips = const [
      Tip('Definisi', 'Topik “Suggestion & Request” mencakup cara memberi saran dan meminta bantuan/izin secara sopan.'),
      Tip('Tujuan', 'Bisa menyarankan solusi dan meminta sesuatu dengan variasi tingkat kesopanan (politeness).'),
      Tip('Politeness', 'Biasanya: would you mind > could you > can you (paling santai).'),
    ];

    final examples = const [
      SugReqVocab(phrase:'You should rest.', indo:'Kamu sebaiknya istirahat.', type:T_SUG, example:'You should see a doctor.'),
      SugReqVocab(phrase:'Could you help me?', indo:'Dapatkah Anda membantu saya?', type:T_REQ, example:'Could you carry this bag?'),
      SugReqVocab(phrase:'Sure, no problem.', indo:'Tentu, tidak masalah.', type:T_RES),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) infoBadge(icon: Icons.info_outline, text: '${t.title}: ${t.text}', color: Colors.blue),
          const SizedBox(height: 16),
          sectionTitle('Contoh Ungkapan', Colors.teal),
          const SizedBox(height: 8),
          for (final v in examples) vocabTile(v, color: Colors.teal, audio: audio),
        ],
      ),
    );
  }
}

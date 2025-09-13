import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../compapo_shared.dart';

class CompApoPengertianTab extends StatelessWidget {
  const CompApoPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    final tips = const [
      Tip('Definisi', 'Topik ini membahas cara menyampaikan keluhan (complaining) dan meminta maaf (apologizing) dengan bahasa yang sopan dan efektif.'),
      Tip('Tujuan', 'Agar mampu menyampaikan masalah dengan jelas, menjaga sopan santun, dan menawarkan/menjawab solusi.'),
      Tip('Nada & Kesantunan', 'Gunakan softener (Could you..., I\'m afraid..., Would it be possible...) untuk meredam nada konfrontatif.'),
    ];

    final examples = const [
      CompApoVocab(phrase: "I'm afraid there's a problem with my order.", indo: 'Sepertinya ada masalah pada pesanan saya.', category: C_COMPLAINT),
      CompApoVocab(phrase: "I'm really sorry for the inconvenience.", indo: 'Saya benar-benar minta maaf atas ketidaknyamanan ini.', category: C_APOLOGY),
      CompApoVocab(phrase: "Let me fix that for you.", indo: 'Biar saya perbaiki untuk Anda.', category: C_SOLUTION),
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
          infoBadge(icon: Icons.lightbulb_outline, text: 'Rumus umum: [Softener] + [Complaint/Apology] + [Detail] + [Solution/Follow-up].'),
        ],
      ),
    );
  }
}

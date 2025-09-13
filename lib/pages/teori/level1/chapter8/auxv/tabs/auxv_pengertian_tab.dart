import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../auxv_shared.dart';

class AuxVPengertianTab extends StatelessWidget {
  const AuxVPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    final tips = const [
      Tip('Definisi', 'Auxiliary verbs (kata kerja bantu) membantu membentuk tenses, kalimat tanya, dan kalimat negatif. Fokus halaman ini: BE, DO, HAVE.'),
      Tip('Tujuan', 'Bisa membentuk pertanyaan, negatif, serta tenses dasar (present/past continuous, present/past perfect).'),
      Tip('Catatan', 'Aux tidak membawa makna leksikal utama; ia mendampingi main verb.'),
    ];

    final examples = const [
      AuxVocab(aux:'be', forms:'am/is/are', function:'present continuous/nominal/passive', category: CAT_BE, example:'She is reading. / They are students.'),
      AuxVocab(aux:'do', forms:'do/does', function:'bantu present simple (tanya/negatif)', category: CAT_DO, example:'Do you play? / He doesn’t play.'),
      AuxVocab(aux:'have', forms:'have/has', function:'present perfect', category: CAT_HAVE, example:'I have finished my work.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) infoBadge(icon: Icons.info_outline, text: '${t.title}: ${t.text}'),
          const SizedBox(height: 16),
          sectionTitle('Contoh', Colors.teal),
          const SizedBox(height: 8),
          for (final v in examples) auxTile(v, color: Colors.teal, audio: audio),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.lightbulb_outline, text: 'Rumus umum tanya/negatif: AUX + subject + V / subject + AUX + not + V.'),
        ],
      ),
    );
  }
}

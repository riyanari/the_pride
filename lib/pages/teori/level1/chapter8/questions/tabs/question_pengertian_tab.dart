import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../question_shared.dart';

class QuestionPengertianTab extends StatelessWidget {
  const QuestionPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    final tips = const [
      Tip('Definisi', 'Question words (kata tanya) digunakan untuk menanyakan orang, benda, tempat, waktu, alasan, cara, jumlah, frekuensi, dll.'),
      Tip('Tujuan', 'Mampu membuat dan memahami pertanyaan yang natural dalam percakapan sehari-hari.'),
      Tip('Posisi', 'Biasanya diletakkan di awal kalimat tanya, diikuti auxiliary verb (do/does/did/is/are/were/will/… ).'),
    ];

    final examples = const [
      QWVocab(word: 'who',   indo: 'siapa', category: CAT_BASIC, example: 'Who is she?'),
      QWVocab(word: 'where', indo: 'di mana', category: CAT_BASIC, example: 'Where do you live?'),
      QWVocab(word: 'how many', indo: 'berapa (bisa dihitung)', category: CAT_COMPOUND, example: 'How many students are there?'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) infoBadge(icon: Icons.info_outline, text: '${t.title}: ${t.text}'),
          const SizedBox(height: 16),
          sectionTitle('Contoh Ungkapan', Colors.teal),
          const SizedBox(height: 8),
          for (final v in examples) qwTile(v, color: Colors.teal, audio: audio),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.lightbulb_outline, text: 'Rumus umum: [QW] + [aux] + [subject] + [verb] + (keterangan) ?'),
        ],
      ),
    );
  }
}

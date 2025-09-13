import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';

import 'package:the_pride/pages/teori/level1/chapter10/procedure/procedures_shared.dart' as proc;

class ProcPengertianTab extends StatelessWidget {
  const ProcPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    final tips = const [
      proc.Tip('Definisi', '“Procedures & Instructions” membahas cara memberikan langkah-langkah (step-by-step), perintah (imperatives), dan penanda urutan.'),
      proc.Tip('Tujuan', 'Agar dapat menjelaskan proses (memasak, merakit, menyetel alat) dengan jelas dan aman.'),
      proc.Tip('Bentuk Umum', 'Gunakan bentuk imperative (V1): Mix…, Press…, Do not…; serta penanda urutan: first, next, then, finally.'),
    ];

    final examples = const [
      proc.ProcVocab(term: 'First, wash the vegetables.', indo: 'Pertama, cuci sayur.', category: proc.C_SEQ),
      proc.ProcVocab(term: 'Preheat the oven to 180°C.', indo: 'Panaskan oven ke 180°C.', category: proc.C_VERB),
      proc.ProcVocab(term: 'Caution: Hot surface.', indo: 'Hati-hati: Permukaan panas.', category: proc.C_NOTICE),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          proc.sectionTitle('Konsep Dasar', Colors.indigo),
          const SizedBox(height: 8),
          for (final t in tips)
            proc.infoBadge(
              icon: Icons.menu_book_outlined,
              text: '${t.title}: ${t.text}',
              color: Colors.indigo,
            ),
          const SizedBox(height: 16),
          proc.sectionTitle('Contoh Ungkapan', Colors.teal),
          const SizedBox(height: 8),
          for (final v in examples) proc.procTile(v, color: Colors.teal, audio: audio),
          const SizedBox(height: 8),
          proc.infoBadge(
            icon: Icons.lightbulb_outline,
            text: 'Imperative: V1 tanpa subject (kamu). Negatif: “Do not/Don’t + V1”. Gunakan penanda urutan untuk kejelasan.',
          ),
        ],
      ),
    );
  }
}

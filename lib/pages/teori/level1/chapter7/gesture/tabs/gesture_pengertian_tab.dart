import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../gesture_shared.dart';

class GesturePengertianTab extends StatelessWidget {
  const GesturePengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    const tips = [
      Tip('Definisi', '“Gesture & body language” adalah komunikasi nonverbal: gerak tangan, kepala, postur, mimik.'),
      Tip('Fungsi', 'Menunjukkan sikap, emosi, dan niat (setuju, ragu, ramah, tidak nyaman).'),
      Tip('Konteks & Budaya', 'Makna gesture bisa berbeda antar budaya. Pilih gesture aman (senyum, angguk ringan).'),
      Tip('Keterpaduan', 'Padukan gesture + nada suara + kata-kata agar pesan konsisten & sopan.'),
    ];

    final examples = [
      kGestureVocab[0], // thumbs-up
      kGestureVocab[1], // nod
      kGestureVocab[3], // wave
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) tipCard(t, Colors.blue),
          const SizedBox(height: 16),
          sectionTitle('Contoh Gestur', Colors.teal),
          const SizedBox(height: 8),
          for (final v in examples) ...[
            gestureTile(v, color: Colors.teal, audio: audio),
            const SizedBox(height: 8),
          ],
          infoBadge(icon: Icons.lightbulb_outline,
              text: 'Gunakan gesture sederhana & universal (senyum, angguk, lambaian) saat bertemu orang baru.'),
        ],
      ),
    );
  }
}

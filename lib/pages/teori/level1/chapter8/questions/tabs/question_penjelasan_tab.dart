import 'package:flutter/material.dart';
import '../question_shared.dart';

class QuestionPenjelasanTab extends StatelessWidget {
  const QuestionPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Polanya gimana?', Colors.indigo),
          const SizedBox(height: 8),
          infoBadge(
            icon: Icons.tips_and_updates,
            text: 'Kalimat tanya informasi: [QW] + [aux/be/modal] + [subject] + [V] + ... ?\n'
                '• Where do you live?\n'
                '• Why are you late?\n'
                '• When will they arrive?',
          ),
          const SizedBox(height: 12),
          sectionTitle('Perbedaan Penting', Colors.orange),
          const SizedBox(height: 8),
          infoBadge(
            icon: Icons.circle,
            text: 'which vs what: "which" untuk pilihan terbatas; "what" untuk umum.\n'
                'whose: menanyakan kepemilikan.\n'
                'whom: objek (lebih formal).',
          ),
          const SizedBox(height: 12),
          sectionTitle('How + Adverb/Adjective', Colors.green),
          const SizedBox(height: 8),
          infoBadge(
            icon: Icons.rule,
            text: 'how many (countable), how much (uncountable/price), how old (umur), how long (durasi), '
                'how far (jarak), how often (frekuensi), how tall/fast/big (ukur/derajat).',
          ),
        ],
      ),
    );
  }
}

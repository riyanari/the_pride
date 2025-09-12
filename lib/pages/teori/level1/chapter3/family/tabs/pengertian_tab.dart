import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter3/family/family_shared.dart';

class FamilyPengertianTab extends StatelessWidget {
  const FamilyPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = const [
      Tip('Apa itu “Family Vocabulary”?', 'Kumpulan kosakata hubungan kekerabatan: keluarga inti (immediate), keluarga besar (extended), mertua (in-law), tiri (step), dan lain-lain.'),
      Tip('Kegunaan', 'Dipakai untuk memperkenalkan anggota keluarga, menyusun silsilah, dan menceritakan hubungan sosial.'),
      Tip('Catatan Budaya', 'Sebutan dan kedekatan bisa berbeda antar budaya. Misalnya penggunaan panggilan untuk yang lebih tua/lebih muda.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) tipCard(t, Colors.blue),
          const SizedBox(height: 16),
          infoBadge(icon: Icons.lightbulb_outline, text: 'Mulai dari kategori “immediate family” seperti mother, father, brother, sister.'),
        ],
      ),
    );
  }
}

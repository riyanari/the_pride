import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter3/hobbies/hobbies_shared.dart';

class HobbiesPengertianTab extends StatelessWidget {
  const HobbiesPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    const tips = [
      Tip('Definisi',
          'Hobby adalah kegiatan yang dilakukan secara teratur untuk kesenangan/relaksasi di waktu luang.'),
      Tip('Fungsi Bahasa',
          'Memperkenalkan minat, membuka percakapan, dan mencari teman dengan ketertarikan yang sama.'),
      Tip('Bentuk Umum',
          'Gunakan gerund (V-ing): “I like reading.” / “I enjoy hiking.”'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) tipCard(t, Colors.blue),
          const SizedBox(height: 16),
          infoBadge(icon: Icons.lightbulb_outline,
              text: 'Polite small talk: “What do you do in your free time?”, “What are you into these days?”'),
        ],
      ),
    );
  }
}

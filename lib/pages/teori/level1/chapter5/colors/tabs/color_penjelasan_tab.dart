import 'package:flutter/material.dart';
import '../color_shared.dart';

class ColorPenjelasanTab extends StatelessWidget {
  const ColorPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final points = const [
      Tip('Membentuk Frasa Warna', 'Urutan umum: opinion → size → age → shape → color → origin → material → purpose → NOUN. (Sederhanakan: size → color → noun).'),
      Tip('Kombinasi', 'Light/dark/bright/pale + color: "light blue", "dark green".'),
      Tip('Pola', 'striped (garis), dotted (bintik), plaid (kotak-kotak).'),
      Tip('Kata Kerja Terkait', 'paint (mengecat), dye (mewarnai kain), mix (mencampur warna).'),
    ];

    final patterns = const [
      Tip('Rumus Deskripsi', '[Subject] + be + [adj color] + [color] + [noun] → "She has a bright red bag."'),
      Tip('Rumus Preferensi', 'I like/prefer + [color] + [noun] → "I prefer black clothes."'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Poin Penting', Colors.purple),
          const SizedBox(height: 8),
          for (final t in points) tipCard(t, Colors.purple),
          const SizedBox(height: 16),
          sectionTitle('Rumus / Pola', Colors.brown),
          const SizedBox(height: 8),
          for (final t in patterns) tipCard(t, Colors.brown),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.check_circle_outline, text: 'Warna jamak tidak berubah bentuk: one red apple, two red apples (adjective tetap).'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter4/numbers/numbers_shared.dart';

class NumbersPengertianTab extends StatelessWidget {
  const NumbersPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    const tips = [
      Tip('Definisi',
          'Numbers (angka) dipakai untuk jumlah (cardinal: one, two, three) dan urutan (ordinal: first, second, third).'),
      Tip('Kegunaan',
          'Mengungkap kuantitas, tanggal, usia, harga, ukuran, peringkat, alamat, dan lebih banyak konteks.'),
      Tip('Bentuk Umum',
          'Cardinal untuk jumlah: “I have two cats.” • Ordinal untuk urutan/ranking: “He won first place.”'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) _tipCard(t, Colors.blue, context),
          const SizedBox(height: 16),
          infoBadge(icon: Icons.lightbulb_outline,
              text: 'Hyphen (-) dipakai pada 21–99 (kecuali puluhan bulat): twenty-one, twenty-two, ...'),
        ],
      ),
    );
  }

  Widget _tipCard(Tip tip, Color color, context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha:0.25)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
    ),
    child: ListTile(
      leading: Icon(Icons.info_outline, color: color),
      title: Text(tip.title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
      subtitle: Text(tip.text),
    ),
  );
}

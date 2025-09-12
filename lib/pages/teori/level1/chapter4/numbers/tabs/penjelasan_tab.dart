import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter4/numbers/numbers_shared.dart';

class NumbersPenjelasanTab extends StatelessWidget {
  const NumbersPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      Tip('Rumus / Pola Umum (Cardinal)',
          '• 21–99: puluhan + hyphen + satuan → twenty-one, forty-two\n'
              '• Ratusan: [number] hundred (+ and + [rest] gaya BrE) → “one hundred (and) twenty-three”\n'
              '• Ribuan/jutaan: gunakan koma: 1,000 (one thousand), 1,000,000 (one million)'),
      Tip('Rumus / Pola Umum (Ordinal)',
          '• 1st first, 2nd second, 3rd third, 4th fourth; 11th eleventh, 12th twelfth, 13th thirteenth\n'
              '• 21st twenty-first, 22nd twenty-second (ordinal menempel pada satuannya)'),
      Tip('Membaca Desimal & Pecahan',
          '• Decimal: 3.14 → “three point one four” (tiap digit setelah titik dibaca per digit)\n'
              '• Fraction: 1/2 “a half”; 1/3 “a third”; 3/4 “three quarters”'),
      Tip('Telepon & Tahun',
          '• Nomor telepon: baca digit per digit: 0812 → “zero eight one two” (BrE: “oh” untuk 0 juga lazim)\n'
              '• Tahun: 1999 → “nineteen ninety-nine”, 2015 → “two thousand (and) fifteen”'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Penjelasan & Rumus', Colors.purple),
          const SizedBox(height: 8),
          for (final t in items) _tipCard(t, Colors.purple, context),
          const SizedBox(height: 16),
          infoBadge(icon: Icons.rule,
              text: 'Ejaan “forty” (bukan *fourty*). “Hundred” & “thousand” tidak pakai jamak saat jadi bilangan: “two hundred”, “three thousand”.'),
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

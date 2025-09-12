import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/time_shared.dart';

class TimePenjelasanTab extends StatelessWidget {
  const TimePenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final points = const [
      Tip('Rumus Telling Time', '[Menit] + past/to + [Jam]\n15 = a quarter, 30 = half\nContoh: a quarter past seven; twenty to five.'),
      Tip('AM/PM', 'AM: 00:00–11:59, PM: 12:00–23:59. Noon = 12:00, Midnight = 00:00.'),
      Tip('Preposisi Waktu', 'at (jam/point): at 7, at noon, at night\non (hari/tanggal): on Monday, on 2nd May\nin (bulan/tahun/periode): in July, in 2025, in the morning'),
      Tip('Frequency Adverbs', 'always, usually, often, sometimes, rarely, never—umumnya diletakkan sebelum main verb: I often read at night.'),
      Tip('24-hour', 'Dalam pengumuman resmi: 18:30 dibaca “eighteen thirty”.'),
    ];

    final wordbank = const {
      'Clock': ['o\'clock', 'quarter past', 'half past', 'quarter to', 'ten past', 'twenty to', 'AM', 'PM', 'noon', 'midnight'],
      'Prepositions': ['at 7 o\'clock', 'on Monday', 'in June', 'at night', 'in the morning'],
      'Time of Day': ['morning', 'afternoon', 'evening', 'night', 'dawn', 'dusk'],
      'Frequency': ['always', 'usually', 'often', 'sometimes', 'rarely', 'never'],
      'Duration': ['minute', 'hour', 'day', 'week', 'month', 'year'],
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Poin Penting', Colors.purple),
          const SizedBox(height: 8),
          for (final p in points) tipCard(p, Colors.purple),
          const SizedBox(height: 16),
          sectionTitle('Word Bank', Colors.indigo),
          const SizedBox(height: 8),
          for (final entry in wordbank.entries) ...[
            Text(entry.key, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8, runSpacing: -6,
              children: [
                for (final s in entry.value)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withValues(alpha:0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.indigo.withValues(alpha:0.25)),
                    ),
                    child: Text(s, style: primaryTextStyle.copyWith(fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

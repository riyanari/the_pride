import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';

import '../compliment_shared.dart';

class PenjelasanTab extends StatelessWidget {
  const PenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    final structures = const [
      Tip('Template Pujian', 'Opener + Compliment Head + (Intensifier) + Target + Reason/Detail + (Follow-up).'),
      Tip('Kategori', '• Performance/effort\n• Ideas/creativity\n• Appearance (hati-hati)\n• Possessions (neutral)\n• Character/kindness'),
      Tip('Softener/Intensifier', 'really, so, absolutely, super, quite, pretty\nGunakan wajar agar tidak berlebihan.'),
    ];

    final responding = const [
      Phrase(phrase: 'Thanks! I appreciate it.', note: 'Terima dengan singkat & tulus.'),
      Phrase(phrase: 'Thanks—that means a lot.', note: 'Menunjukkan dampak positif.'),
      Phrase(phrase: 'Thanks, but I couldn\'t have done it without the team.', note: 'Memberi kredit ke orang lain (humble).'),
      Phrase(phrase: 'Thank you! I\'m glad you liked it.', note: 'Balasan hangat + small talk lanjutan.'),
    ];

    final formulas = const [
      Formula(
        title: 'Rumus: Memberi Pujian (Giving Compliment)',
        pattern: '[Opener] + [Compliment Head] + ([Intensifier]) + [Target] + ([Reason/Detail]) + ([Follow-up])',
        examples: [
          'I just wanted to say, great job [Compliment Head] on your presentation [Target]—especially the visuals [Reason].',
          'That\'s a really [Intensifier] creative [Compliment Head] idea [Target]!',
        ],
      ),
      Formula(
        title: 'Rumus: Merespons Pujian (Responding)',
        pattern: '[Thanks] + ([Appreciation]) + ([Modesty/Credit]) + ([Follow-up])',
        examples: [
          'Thanks [Thanks]—I really appreciate it [Appreciation].',
          'Thank you [Thanks]! Couldn\'t have done it without the team [Modesty/Credit].',
        ],
      ),
    ];

    final wordBank = const WordBank(
      openers: ['I just wanted to say…', 'I really think…', 'Can I just say…', 'If I may…'],
      heads: ['great job', 'nice work', 'fantastic idea', 'impressive design', 'thoughtful feedback', 'kind gesture'],
      intensifiers: ['really', 'so', 'absolutely', 'super', 'quite', 'pretty'],
      targets: ['on your presentation', 'with your report', 'about your idea', 'on that project', 'with the team'],
      reasons: ['especially the visuals', 'because it solves the problem', '—it really helped the team', '—it was exactly what we needed'],
      followups: ['Keep it up!', 'Would you share how you did it?', 'Let\'s discuss it more later.', 'I learned a lot from it.'],
      thanks: ['Thanks!', 'Thank you!', 'Much appreciated.'],
      appreciation: ['I appreciate it.', 'That means a lot.', 'I\'m glad you liked it.'],
      modesty: ['Couldn\'t have done it without the team.', 'I just got lucky.', 'Your feedback helped a lot.'],
    );

    final mistakes = const [
      Tip('Menolak pujian secara ekstrem', 'Mengatakan “No, it\'s nothing.” terus-menerus dapat terdengar tidak sopan. Cukup terima, lalu merendah seperlunya.'),
      Tip('Berlebihan', 'Intensifier berlebihan membuat tidak natural. Pilih 1 kata penguat saja.'),
      Tip('Topik sensitif', 'Hindari komentar fisik/privasi jika belum dekat.'),
      Tip('Tidak ada alasan', 'Tambahkan detail/alasannya agar pujian terasa tulus.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Struktur & Frase', Colors.purple),
          const SizedBox(height: 8),
          for (final t in structures) tipCard(t, Colors.purple),
          const SizedBox(height: 16),
          sectionTitle('Rumus / Pola', Colors.brown),
          const SizedBox(height: 8),
          for (final f in formulas) formulaCard(f, Colors.brown),
          const SizedBox(height: 16),
          sectionTitle('Word Bank (Kumpulan Frasa)', Colors.indigo),
          const SizedBox(height: 8),
          wordBankCard(wordBank, Colors.indigo),
          const SizedBox(height: 16),
          sectionTitle('Responding to Compliments', Colors.teal),
          const SizedBox(height: 8),
          for (final p in responding) phraseCard(p, color: Colors.teal, audio: audio),
          const SizedBox(height: 16),
          sectionTitle('Kesalahan Umum', Colors.red),
          const SizedBox(height: 8),
          for (final t in mistakes) tipCard(t, Colors.red),
          const SizedBox(height: 16),
          sectionTitle('Do & Don\'t', Colors.orange),
          const SizedBox(height: 8),
          for (final t in const [
            Tip('Do', 'Spesifik, relevan konteks, jaga nada suaranya, dan ikuti dengan follow-up kecil.'),
            Tip('Don\'t', 'Jangan berlebihan, jangan membandingkan dengan orang lain, hindari topik sensitif tanpa kedekatan.'),
          ]) tipCard(t, Colors.orange),
        ],
      ),
    );
  }
}

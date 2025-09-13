import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../sugreq_shared.dart';

class SugReqPenjelasanTab extends StatelessWidget {
  const SugReqPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          const _PenjelasanContent(),
          const SizedBox(height: 16),

          // ===== Contoh Dialog =====
          sectionTitle('Contoh Dialog', Colors.teal),
          const SizedBox(height: 8),
          _dialogCard(
            'Suggestion (saran)',
            [
              'A: I’m bored.',
              'B: How about watching a movie?',
              'A: Good idea!'
            ],
            color: Colors.teal,
          ),
          const SizedBox(height: 10),
          _dialogCard(
            'Request (permintaan)',
            [
              'A: Could you open the window, please?',
              'B: Sure, no problem.'
            ],
            color: Colors.teal,
          ),
          const SizedBox(height: 10),
          _dialogCard(
            'Would you mind',
            [
              'A: Would you mind turning the music down?',
              'B: Not at all. (dengan senang hati)'
            ],
            color: Colors.teal,
          ),
          const SizedBox(height: 10),
          _dialogCard(
            'If I were you',
            [
              'A: I failed the test.',
              'B: If I were you, I would talk to the teacher.'
            ],
            color: Colors.teal,
          ),

          const SizedBox(height: 16),

          // ===== Kesalahan Umum =====
          sectionTitle('Kesalahan Umum', Colors.deepOrange),
          const SizedBox(height: 8),
          infoBadge(
            icon: Icons.error_outline,
            text: '✗ suggest to go  →  ✓ suggest going / suggest (that) you go',
            color: Colors.deepOrange,
          ),
          infoBadge(
            icon: Icons.error_outline,
            text: '✗ would you mind to open  →  ✓ would you mind opening',
            color: Colors.deepOrange,
          ),
          infoBadge(
            icon: Icons.error_outline,
            text: '✗ can you to help me  →  ✓ can you help me',
            color: Colors.deepOrange,
          ),
          infoBadge(
            icon: Icons.error_outline,
            text: 'Jawaban yang tepat untuk “Would you mind …?” bila setuju: “Not at all.” (bukan “Yes”).',
            color: Colors.deepOrange,
          ),

          const SizedBox(height: 16),

          // ===== Tingkat Kesopanan =====
          sectionTitle('Tingkat Kesopanan', Colors.purple),
          const SizedBox(height: 8),
          _levelTile(
            'Casual',
            [
              'Let’s + V1 (Let’s go!)',
              'Why don’t we + V1',
              'Can you + V1 …?'
            ],
            color: Colors.purple,
          ),
          const SizedBox(height: 8),
          _levelTile(
            'Neutral',
            [
              'How about + V-ing',
              'Could you + V1 …?',
              'I suggest (that) you + V1'
            ],
            color: Colors.purple,
          ),
          const SizedBox(height: 8),
          _levelTile(
            'Formal / Very Polite',
            [
              'Would you mind + V-ing …?',
              'Would it be possible to + V1 …?',
              'If I were you, I would + V1'
            ],
            color: Colors.purple,
          ),
        ],
      ),
    );
  }
}

/// Gunakan widget ini di atas ListView bila mau ringkas:
class _PenjelasanContent extends StatelessWidget {
  const _PenjelasanContent();

  @override
  Widget build(BuildContext context) {
    final items = const [
      Tip(
        'Suggestion Patterns',
        'You should + V1; How about + V-ing; Why don’t you + V1; Let’s + V1; '
            'If I were you, I would …; I suggest (that) you + V1',
      ),
      Tip(
        'Request Patterns',
        'Can/Could you + V1 …?; Would you mind + V-ing …?; '
            'May/Can I + V1 …? (izin)',
      ),
      Tip(
        'Catatan',
        '“Would you mind + V-ing …?” → jawaban positif memakai “Not at all.”',
      ),
      Tip(
        'Kesopanan',
        'Urutan sopan (umum): would you mind > could you > can you. Pilih sesuai konteks.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('Rangkuman Pola', Colors.indigo),
        const SizedBox(height: 8),
        for (final t in items)
          infoBadge(
            icon: Icons.bookmark_border,
            text: '${t.title}: ${t.text}',
            color: Colors.indigo,
          ),
      ],
    );
  }
}

/// Kartu dialog contoh
Widget _dialogCard(String title, List<String> lines, {Color color = Colors.teal}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha:0.25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.06),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        for (final l in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• $l', style: primaryTextStyle),
          ),
      ],
    ),
  );
}

/// Kartu ringkas tingkat kesopanan
Widget _levelTile(String level, List<String> forms, {Color color = Colors.purple}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha:0.25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.06),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(level, style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        for (final f in forms)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text('• $f', style: primaryTextStyle),
          ),
      ],
    ),
  );
}

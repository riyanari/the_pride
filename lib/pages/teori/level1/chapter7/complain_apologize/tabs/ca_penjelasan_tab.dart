import 'package:flutter/material.dart';
import '../compapo_shared.dart';

class CompApoPenjelasanTab extends StatelessWidget {
  const CompApoPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final formulas = const [
      Tip('Rumus: Complaining', '[Softener] + [Issue] + [Detail/Impact] + [Request]\nContoh: "I\'m afraid my internet is down (issue). Could you check it, please? (request)"'),
      Tip('Rumus: Apologizing', '[Sorry/Apology] + [Reason (opsional)] + [Responsibility] + [Solution/Promise]\nContoh: "I\'m really sorry for the delay. It was my fault. I\'ll send it today."'),
      Tip('Softener & Hedging', 'I\'m afraid..., I wonder if..., Could you possibly..., Would it be possible to..., It seems that...'),
      Tip('Follow-ups', 'Is there anything else I can help you with? / Thanks for your patience.'),
    ];

    final dos = const [
      Tip('Do', 'Spesifik, sopan, dan berorientasi solusi.'),
      Tip('Don\'t', 'Hindari menyalahkan berlebihan atau nada agresif.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Rumus & Strategi', Colors.purple),
          const SizedBox(height: 8),
          for (final t in formulas) tipCard(t, Colors.purple),
          const SizedBox(height: 16),
          sectionTitle('Do & Don\'t', Colors.orange),
          const SizedBox(height: 8),
          for (final t in dos) tipCard(t, Colors.orange),
        ],
      ),
    );
  }
}

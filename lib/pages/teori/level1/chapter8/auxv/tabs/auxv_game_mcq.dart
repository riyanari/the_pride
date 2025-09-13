import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../auxv_shared.dart';

class AuxVMCQGame extends StatefulWidget {
  const AuxVMCQGame({super.key});
  @override
  State<AuxVMCQGame> createState() => _AuxVMCQGameState();
}

class _AuxVMCQGameState extends State<AuxVMCQGame> {
  final r = Random();
  late List<MCQItem> _items;
  final Map<int,int?> _chosen = {};

  @override
  void initState() {
    super.initState();
    _items = [
      MCQItem(
        prompt: '___ you like coffee?',
        options: ['Do', 'Are', 'Have'],
        correct: 0,
        explain: '"Do" untuk present simple question (you).',
      ),
      MCQItem(
        prompt: 'She ___ not play tennis.',
        options: ['does', "doesn't", 'did'],
        correct: 1,
        explain: 'Negatif present simple pihak ketiga: doesn’t + V1.',
      ),
      MCQItem(
        prompt: 'They ___ watching a movie.',
        options: ['are', 'do', 'have'],
        correct: 0,
        explain: 'Present continuous: are + V-ing.',
      ),
      MCQItem(
        prompt: '___ she finished her homework?',
        options: ['Has', 'Is', 'Does'],
        correct: 0,
        explain: 'Present perfect: Has + V3.',
      ),
      MCQItem(
        prompt: 'We ___ at the library yesterday.',
        options: ['are', 'were', 'have been'],
        correct: 1,
        explain: 'Nominal past: were.',
      ),
      MCQItem(
        prompt: '___ you go there last night?',
        options: ['Do', 'Did', 'Were'],
        correct: 1,
        explain: 'Past simple question: Did + subject + V1.',
      ),
    ]..shuffle(r);
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.indigo;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final q = _items[i];
          final sel = _chosen[i];
          final isCorrect = sel != null && sel == q.correct;
          return Container(
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green.withValues(alpha:0.06) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: (sel == null) ? Colors.grey.withValues(alpha:0.3) : (isCorrect ? Colors.green : Colors.red)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.prompt, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: [
                      for (int oi=0; oi<q.options.length; oi++)
                        ChoiceChip(
                          label: Text(q.options[oi]),
                          selected: sel == oi,
                          onSelected: (_) => setState(() => _chosen[i] = oi),
                          selectedColor: color.withValues(alpha:0.2),
                        ),
                    ],
                  ),
                  if (sel != null) ...[
                    const SizedBox(height: 6),
                    Text(q.explain, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

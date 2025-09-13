import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../question_shared.dart';

class QuestionMCQGame extends StatefulWidget {
  const QuestionMCQGame({super.key});
  @override
  State<QuestionMCQGame> createState() => _QuestionMCQGameState();
}

class _QuestionMCQGameState extends State<QuestionMCQGame> {
  final r = Random();
  late List<MCQItem> _items;
  final Map<int,int?> _chosen = {}; // idx -> selected

  @override
  void initState() {
    super.initState();
    _items = [
      MCQItem(
        prompt: '___ is your name?',
        options: ['What', 'Which', 'Who'],
        correct: 0,
        explain: '"What" untuk menanyakan informasi umum (nama).',
      ),
      MCQItem(
        prompt: '___ do you live?',
        options: ['Where', 'When', 'Why'],
        correct: 0,
        explain: '"Where" menanyakan lokasi/tempat.',
      ),
      MCQItem(
        prompt: '___ are you late?',
        options: ['How', 'Why', 'When'],
        correct: 1,
        explain: '"Why" menanyakan alasan.',
      ),
      MCQItem(
        prompt: '___ many brothers do you have?',
        options: ['How', 'How much', 'How many'],
        correct: 2,
        explain: '"How many" untuk countable.',
      ),
      MCQItem(
        prompt: '___ old is your father?',
        options: ['What', 'How', 'How old'],
        correct: 2,
        explain: '"How old" untuk umur.',
      ),
      MCQItem(
        prompt: '___ bag is yours?',
        options: ['Whose', 'Whom', 'Which'],
        correct: 0,
        explain: '"Whose" menanyakan kepemilikan.',
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

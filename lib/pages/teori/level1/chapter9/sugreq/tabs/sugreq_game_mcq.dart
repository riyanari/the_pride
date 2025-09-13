import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../sugreq_shared.dart';

class SugReqMCQGame extends StatefulWidget {
  const SugReqMCQGame({super.key});
  @override
  State<SugReqMCQGame> createState() => _SugReqMCQGameState();
}

class _SugReqMCQGameState extends State<SugReqMCQGame> {
  final _items = <MCQItem>[
    MCQItem(
      prompt: '___ you open the door, please?',
      options: ['Can', 'May', 'Would you mind'],
      correct: 0,
      explain: 'Permintaan netral: “Can you ...?”',
    ),
    MCQItem(
      prompt: '___ I borrow your pen?',
      options: ['Can', 'Could', 'May'],
      correct: 2,
      explain: 'Meminta izin formal: “May I ...?”',
    ),
    MCQItem(
      prompt: '___ trying a different route?',
      options: ['How about', 'You should', 'Let’s'],
      correct: 0,
      explain: 'Saran santai: “How about + V-ing ...?”',
    ),
    MCQItem(
      prompt: '___ you mind closing the window?',
      options: ['Do', 'Would', 'Could'],
      correct: 1,
      explain: 'Sangat sopan: “Would you mind + V-ing ...?”',
    ),
    MCQItem(
      prompt: 'I suggest that you ___ earlier.',
      options: ['to arrive', 'arrive', 'arrives'],
      correct: 1,
      explain: 'Subjunctive: “I suggest (that) you + V1” → arrive.',
    ),
  ];

  late List<int?> _answers;

  @override
  void initState() { super.initState(); _answers = List.filled(_items.length, null); }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Text('MCQ', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final it = _items[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withValues(alpha:0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it.prompt, style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        for (int o = 0; o < it.options.length; o++)
                          RadioListTile<int>(
                            contentPadding: EdgeInsets.zero,
                            value: o,
                            groupValue: _answers[i],
                            title: Text(it.options[o], style: primaryTextStyle),
                            onChanged: (v) => setState(() => _answers[i] = v),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Submit Skor'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    int correct = 0;
    for (int i = 0; i < _items.length; i++) {
      if (_answers[i] == _items[i].correct) correct++;
    }
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'Skor MCQ',
      desc: 'Benar: $correct / ${_items.length}',
      btnOkOnPress: () {},
    ).show();
  }
}

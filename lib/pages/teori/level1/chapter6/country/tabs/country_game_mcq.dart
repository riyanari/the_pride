import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../country_shared.dart';

class CountryMCQGame extends StatefulWidget {
  const CountryMCQGame({super.key});
  @override
  State<CountryMCQGame> createState() => _CountryMCQGameState();
}

class _CountryMCQGameState extends State<CountryMCQGame> {
  final r = Random();
  late List<MCQItem> _items;
  final Map<int,int> _ans = {};

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    _items = [
      const MCQItem(
        prompt: 'People from Japan are …',
        options: ['Japanese', 'Japanish', 'Japaneses'],
        correct: 0,
        explain: 'Demonym yang benar: Japanese.',
      ),
      const MCQItem(
        prompt: 'The capital of Germany is …',
        options: ['Munich', 'Berlin', 'Frankfurt'],
        correct: 1,
        explain: 'Ibu kota Jerman adalah Berlin.',
      ),
      const MCQItem(
        prompt: 'They speak … in Brazil.',
        options: ['Spanish', 'Portuguese', 'French'],
        correct: 1,
        explain: 'Bahasa resmi Brasil adalah Portuguese.',
      ),
      const MCQItem(
        prompt: '“I am from Indonesia.” Which is correct?',
        options: ['I am Indonesian.', 'I am Indonesia.', 'I am Indonesia people.'],
        correct: 0,
        explain: 'Gunakan nationality adjective: Indonesian.',
      ),
      const MCQItem(
        prompt: 'Ottawa is the capital of …',
        options: ['Australia', 'Canada', 'United Kingdom'],
        correct: 1,
        explain: 'Ibu kota Kanada adalah Ottawa.',
      ),
    ]..shuffle(r);
    _ans.clear();
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.indigo;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView.separated(
        itemCount: _items.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          if (i == _items.length) {
            return Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Submit Skor'),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: _setup,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            );
          }
          final q = _items[i];
          final sel = _ans[i];
          final ok = sel != null && sel == q.correct;
          return Container(
            decoration: BoxDecoration(
              color: ok ? Colors.green.withValues(alpha:0.06) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha:0.25)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.prompt, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                  const SizedBox(height: 6),
                  for (var j=0; j<q.options.length; j++)
                    RadioListTile<int>(
                      dense: true,
                      value: j,
                      groupValue: sel,
                      onChanged: (v) => setState(() => _ans[i] = v!),
                      title: Text(q.options[j], style: primaryTextStyle),
                    ),
                  if (sel != null)
                    Row(
                      children: [
                        Icon(sel == q.correct ? Icons.check_circle : Icons.cancel,
                            color: sel == q.correct ? Colors.green : Colors.red, size: 18),
                        const SizedBox(width: 6),
                        Expanded(child: Text(q.explain, style: primaryTextStyle.copyWith(fontSize: 12))),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit() {
    int correct = 0;
    for (var i=0; i<_items.length; i++) {
      if (_ans[i] == _items[i].correct) correct++;
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

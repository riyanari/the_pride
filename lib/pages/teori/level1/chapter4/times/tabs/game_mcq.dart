import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/time_shared.dart';

class TimeMcqGame extends StatefulWidget {
  const TimeMcqGame({super.key});
  @override
  State<TimeMcqGame> createState() => _TimeMcqGameState();
}

class _TimeMcqGameState extends State<TimeMcqGame> {
  final r = Random();
  late List<MCQItem> _items;
  final Map<int,int> _selected = {};

  @override
  void initState() {
    super.initState();
    _items = [
      MCQItem(
        prompt: 'Pilih preposisi yang tepat: ___ 7 o\'clock',
        options: ['in','on','at'],
        correct: 2,
        explain: 'Jam spesifik → pakai “at”.',
      ),
      MCQItem(
        prompt: 'Pilih preposisi yang tepat: ___ Monday',
        options: ['at','on','in'],
        correct: 1,
        explain: 'Hari/tanggal → “on”.',
      ),
      MCQItem(
        prompt: 'Pilih preposisi yang tepat: ___ the morning',
        options: ['on','in','at'],
        correct: 1,
        explain: 'Periode (bulan/tahun/part of day) → “in”.',
      ),
      MCQItem(
        prompt: '12:45 dibaca paling natural:',
        options: ['twelve forty-five', 'a quarter to one', 'half to one'],
        correct: 1,
        explain: 'Umum: “a quarter to one”. (formal bisa “twelve forty-five”).',
      ),
    ]..shuffle(r);
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.blue;
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
                  onPressed: () => setState(() { _selected.clear(); _items.shuffle(r); }),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            );
          }
          final q = _items[i];
          final sel = _selected[i];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha:0.25)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.prompt, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                  const SizedBox(height: 6),
                  for (var j = 0; j < q.options.length; j++)
                    RadioListTile<int>(
                      dense: true, contentPadding: EdgeInsets.zero,
                      value: j, groupValue: sel,
                      onChanged: (v) => setState(() => _selected[i] = v!),
                      title: Text(q.options[j], style: primaryTextStyle),
                    ),
                  if (sel != null) _feedback(sel == q.correct, q.explain),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _feedback(bool ok, String explain) {
    final c = ok ? Colors.green : Colors.red;
    final t = ok ? 'Benar! 🎉' : 'Kurang tepat.';
    return Row(
      children: [
        Icon(ok ? Icons.check_circle : Icons.cancel, color: c, size: 18),
        const SizedBox(width: 6),
        Expanded(child: Text('$t $explain', style: primaryTextStyle.copyWith(fontSize: 12, color: c.shade700))),
      ],
    );
  }

  void _submit() {
    int correct = 0;
    for (var i = 0; i < _items.length; i++) {
      final sel = _selected[i];
      if (sel != null && sel == _items[i].correct) correct++;
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

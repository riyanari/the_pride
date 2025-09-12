import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../map_direction_shared.dart';

class MapDirMCQGame extends StatefulWidget {
  const MapDirMCQGame({super.key});
  @override
  State<MapDirMCQGame> createState() => _MapDirMCQGameState();
}

class _MapDirMCQGameState extends State<MapDirMCQGame> {
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
        prompt: '“The café is ___ the library.”',
        options: ['next to', 'between', 'under'],
        correct: 0,
        explain: '“next to” = di sebelah.',
      ),
      const MCQItem(
        prompt: '“Go straight for two ___, then turn left.”',
        options: ['blocks', 'miles', 'corners'],
        correct: 0,
        explain: 'Penanda jarak kota: blocks.',
      ),
      const MCQItem(
        prompt: 'Which is natural?',
        options: ['Turn right at the traffic light.', 'Turn right on the red light.', 'Turn right to the red lamp.'],
        correct: 0,
        explain: 'Ungkapan baku: at the traffic light.',
      ),
      const MCQItem(
        prompt: '“The bank is ___ the post office and the park.”',
        options: ['between', 'behind', 'across from'],
        correct: 0,
        explain: 'between A and B = di antara dua objek.',
      ),
      const MCQItem(
        prompt: 'How to politely ask for directions?',
        options: ['Excuse me, where is the station?', 'Hey! Station?', 'Give me the way!'],
        correct: 0,
        explain: 'Gunakan “Excuse me …” untuk sopan.',
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

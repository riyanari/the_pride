import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../compapo_shared.dart';

class CompApoMCQGame extends StatefulWidget {
  const CompApoMCQGame({super.key});

  @override
  State<CompApoMCQGame> createState() => _CompApoMCQGameState();
}

class _CompApoMCQGameState extends State<CompApoMCQGame> {
  final r = Random();
  late List<MCQItem> _items;
  final Map<int, int> _selected = {};

  @override
  void initState() {
    super.initState();
    _items = [
      const MCQItem(
        prompt: 'Pelanggan: "This item arrived damaged." Respon terbaik?',
        options: ["That's your problem.", "I'm really sorry about that. We can replace it today.", "Wait."],
        correct: 1,
        explain: 'Minta maaf + tawarkan solusi konkret.',
      ),
      const MCQItem(
        prompt: 'Cara mengeluh sopan adalah...',
        options: ["You are so slow!", "I'm afraid my order is late. Could you check it, please?", "Give me a refund now!"],
        correct: 1,
        explain: 'Gunakan softener + permintaan sopan.',
      ),
      const MCQItem(
        prompt: 'Setelah minta maaf, kalimat penutup yang tepat...',
        options: ["Whatever.", "Thanks for your patience.", "It\'s not my fault."],
        correct: 1,
        explain: 'Follow-up positif menjaga hubungan.',
      ),
    ]..shuffle(r);
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.blueGrey;
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
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: j,
                      groupValue: sel,
                      onChanged: (v) => setState(() => _selected[i] = v!),
                      title: Text(q.options[j], style: primaryTextStyle),
                    ),
                  if (sel != null)
                    _feedback(sel == q.correct, q.explain),
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
}

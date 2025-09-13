import 'dart:math';
import 'package:flutter/material.dart';
import '../gesture_shared.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class GestureMCQGame extends StatefulWidget {
  const GestureMCQGame({super.key});
  @override
  State<GestureMCQGame> createState() => _GestureMCQGameState();
}

class _GestureMCQGameState extends State<GestureMCQGame> {
  final r = Random();
  late List<MCQItem> _mcq;
  final Map<int, int> _selected = {}; // idx -> option

  @override
  void initState() {
    super.initState();
    _mcq = [
      const MCQItem(
        prompt: '“OK sign” (👌) aman digunakan di semua negara?',
        options: ['Benar', 'Salah'],
        correct: 1,
        explain: 'Tidak. Di beberapa negara, gesture ini ofensif. Gunakan dengan hati-hati.',
      ),
      const MCQItem(
        prompt: 'Gestur paling aman saat pertama kali bertemu orang baru?',
        options: ['Menunjuk lawan bicara', 'Senyum + angguk ringan', 'Crossed arms'],
        correct: 1,
        explain: 'Senyum + angguk ringan paling netral & ramah.',
      ),
      const MCQItem(
        prompt: 'Di budaya Jepang, “bow” menandakan…',
        options: ['Penghormatan', 'Penolakan', 'Candaan'],
        correct: 0,
        explain: 'Bow = penghormatan; kedalaman bow punya makna.',
      ),
    ]..shuffle(r);
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.blue;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView.separated(
        itemCount: _mcq.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          if (i == _mcq.length) {
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
                  onPressed: () => setState(() { _selected.clear(); _mcq.shuffle(r); }),
                  icon: const Icon(Icons.refresh), label: const Text('Reset'),
                ),
              ],
            );
          }
          final q = _mcq[i];
          final sel = _selected[i];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12),
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
                  for (var j = 0; j < q.options.length; j++)
                    RadioListTile<int>(
                      dense: true, contentPadding: EdgeInsets.zero,
                      value: j, groupValue: sel,
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
    for (var i = 0; i < _mcq.length; i++) {
      final sel = _selected[i];
      if (sel != null && sel == _mcq[i].correct) correct++;
    }
    AwesomeDialog(
      context: context, dialogType: DialogType.success,
      title: 'Skor MCQ', desc: 'Benar: $correct / ${_mcq.length}', btnOkOnPress: () {},
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

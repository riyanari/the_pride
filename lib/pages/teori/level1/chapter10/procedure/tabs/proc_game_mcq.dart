import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../procedures_shared.dart';

class ProcMCQGame extends StatefulWidget {
  const ProcMCQGame({super.key});
  @override
  State<ProcMCQGame> createState() => _ProcMCQGameState();
}

class _ProcMCQGameState extends State<ProcMCQGame> {
  final r = Random();
  late List<MCQItem> _items;
  int _i = 0;
  int? _sel;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _items = [
      MCQItem(
        prompt: 'Penanda urutan yang tepat untuk langkah pertama adalah …',
        options: ['finally', 'first', 'meanwhile'],
        correct: 1,
        explain: '“first” untuk langkah awal.',
      ),
      MCQItem(
        prompt: 'Negatif imperative yang tepat:',
        options: ['Not mix the eggs.', 'Do not mix the eggs.', 'No mix the eggs.'],
        correct: 1,
        explain: 'Bentuk negatif: “Do not/Don’t + V1”.',
      ),
      MCQItem(
        prompt: 'Kalimat yang paling jelas sebagai instruksi:',
        options: ['You should.', 'Mix the batter for 2 minutes.', 'It is mixing.'],
        correct: 1,
        explain: 'Instruksi spesifik + durasi membuatnya jelas.',
      ),
    ]..shuffle(r);
  }

  void _submit() {
    if (_sel == null) return;
    final ok = _sel == _items[_i].correct;
    if (ok) _score++;
    AwesomeDialog(
      context: context,
      dialogType: ok ? DialogType.success : DialogType.info,
      title: ok ? 'Benar!' : 'Kurang tepat',
      desc: _items[_i].explain,
      btnOkOnPress: () {
        if (_i < _items.length - 1) {
          setState(() { _i++; _sel = null; });
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Selesai',
            desc: 'Skor: $_score / ${_items.length}',
            btnOkOnPress: () { setState(() { _i = 0; _sel = null; _score = 0; _items.shuffle(r); }); },
          ).show();
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final q = _items[_i];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('MCQ', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              Text('Skor: $_score', style: primaryTextStyle),
            ],
          ),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.help_outline, text: 'Pilih jawaban terbaik.'),
          const SizedBox(height: 8),
          Text(q.prompt, style: primaryTextStyle),
          const SizedBox(height: 8),
          for (int i = 0; i < q.options.length; i++)
            RadioListTile<int>(
              value: i,
              groupValue: _sel,
              title: Text(q.options[i], style: primaryTextStyle),
              onChanged: (v) => setState(() => _sel = v),
            ),
          const Spacer(),
          ElevatedButton.icon(onPressed: _submit, icon: const Icon(Icons.check), label: const Text('Submit')),
        ],
      ),
    );
  }
}
